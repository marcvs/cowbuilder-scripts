#!/bin/bash

# find md docs in update-debian-repo.sh.md
# (in the same folder as this executable)

ORIG_IFS=$IFS
REMOTE=root@repo.data.kit.edu
R_BASE=/var/www/staging
#R_BASE=/var/www
TMP=`mktemp -d`
MD_INPUT_FILE=$(cd "`dirname $0`" 2>/dev/null && pwd)/update-debian-repo.sh.md
YUM_REPO_PUBKEY=$(cd "`dirname $0`" 2>/dev/null && pwd)/repo-data-kit-edu-key.gpg
YUM_REPO_CENTOS7=$(cd "`dirname $0`" 2>/dev/null && pwd)/data-kit-edu-centos7.repo
YUM_REPO_CENTOS8=$(cd "`dirname $0`" 2>/dev/null && pwd)/data-kit-edu-centos8.repo
YUM_REPO_CENTOS_STREAM=$(cd "`dirname $0`" 2>/dev/null && pwd)/data-kit-edu-centos-stream.repo
YUM_REPO_ROCKY8=$(cd "`dirname $0`" 2>/dev/null && pwd)/data-kit-edu-rockylinux8.repo
YUM_REPO_ROCKY85=$(cd "`dirname $0`" 2>/dev/null && pwd)/data-kit-edu-rockylinux8.5.repo
YUM_REPO_FEDORA36=$(cd "`dirname $0`" 2>/dev/null && pwd)/data-kit-edu-fedora.repo

DISTROS="\
    debian/buster \
    debian/bullseye \
    debian/bookworm \
    ubuntu/focal \
    ubuntu/jammy \
    ubuntu/impish \
    ubuntu/bionic \
    ubuntu/hirsute \
    ubuntu/kinetic \
"
YUM_DISTROS="\
    fedora/36 \
    rockylinux/8 \
    rockylinux/8.5 \
    centos/8 \
    centos/stream \
    centos/7 \
"
ZYPPER_DISTROS="\
    opensuse/15.2 \
    opensuse/15.4 \
    opensuse/tumbleweed \
    opensuse/15.3 \
"

export GNUPGHOME=$HOME/.gnupg
export KEYNAME="ACDFB08FDC962044D87FF00B512839863D487A87"
BUILD_UID=1000
BUILD_USER=build
CICD_UID=1001
CICD_USER=cicd
VERBOSE=""


usage(){
    echo "--distro          <distro>/<release>, e.g.: debian/devel, default: all"
    echo "-y|--yumdistro)   <specify yum distro> e.g.: centos/7, default: all"
    echo "--production)     Apply on production"
    echo "-v|--verbose)     Ve verbose"
    exit 0
}
while [ $# -gt 0 ]; do
    case "$1" in
    -h|--help)          usage               exit 0                    ;;
    -d|--distro)           DISTROS=${2} ; YUM_DISTROS="";       shift ;;
    -y|--yumdistro)        YUM_DISTROS=${2} ; DISTROS="";       shift ;;
    --production)           R_BASE="/var/www"                         ;;
    -v|--verbose)           VERBOSE="true"                            ;;
    esac
    shift
done



[ "x${R_BASE}" == "x/var/www/staging" ] && {
    echo -e "\nWorking on STAGING environment. (Use --production to work on production)\n\n"
}

echo "DEB_DISTROS:"
for i in ${DISTROS}; do
    echo "    $i"
done

echo "YUM_DISTROS:"
for i in ${YUM_DISTROS}; do
    echo "    $i"
done

echo ""

AUX_FILES="$YUM_REPO_PUBKEY $YUM_REPO_CENTOS7 $YUM_REPO_CENTOS8 $YUM_REPO_CENTOS_STREAM $YUM_REPO_ROCKY8 $YUM_REPO_ROCKY85 $YUM_REPO_FEDORA36"

echo -n "Copy auxiliary files..."


# Generate index.html
STYLE_FILE=`dirname $0`/style_internal_css.html
OUTPUT_FILE=$TMP/index.html

test -e $STYLE_FILE || {
    echo "" > $OUTPUT_FILE
}
test -e $STYLE_FILE && {
    cat $STYLE_FILE > $OUTPUT_FILE
}

# Only for real repo:
#echo "pandoc -f gfm -t html $MD_INPUT_FILE   >> $OUTPUT_FILE"
[ "x${R_BASE}" == "x/var/www/staging" ] || {
    echo "Updating the repo readme"
    pandoc -f gfm -t html $MD_INPUT_FILE >> $OUTPUT_FILE
    scp $OUTPUT_FILE $REMOTE:/$R_BASE/ > /dev/null || echo "error with ssh"

    # copy AUX_FILES
    for i in $AUX_FILES; do 
        scp $i $REMOTE:/$R_BASE/ > /dev/null || echo "error copying AUX_FILES"
    done
}
echo " done"

cd $TMP

#########################################################################
# DEB REPOS
IFS="____"
[ -z ${DISTROS} ] || echo "Update deb Repos:"
IFS=$ORIG_IFS
for d in $DISTROS ; do
    echo -n "$d: create-remote..."
    ssh $REMOTE "
        cd $R_BASE/$d

        #-- build Packages file
        apt-ftparchive packages . > Packages
        bzip2 -kf Packages

        #-- signed Release file
        apt-ftparchive release . > Release

        test -e Release.gpg && rm Release.gpg
        #gpg --yes -abs -u $KEYNAME -o Release.gpg Release
        "
    echo -n " sign-locally..."
    mkdir -p $TMP/$d
    scp $REMOTE:$R_BASE/$d/Release $TMP/$d  > /dev/null || echo "error with ssh"
    gpg --yes -abs -u $KEYNAME -o $d/Release.gpg $d/Release
    echo -n " upload..."
    scp $TMP/$d/Release.gpg $REMOTE:$R_BASE/$d/ > /dev/null || echo "error with ssh"
    echo " done"
done

#########################################################################
# YUM REPOS

IFS="____"
[ -z ${YUM_DISTROS} ] || echo -e "\nUpdating yum Repos:"
IFS=$ORIG_IFS

# since this is a bit weird:
# - We sign as root (to avoid touching the cicd users ssh-keys)
# - After signing the rpms are owned by root, so we chown them back to the
#   correct ${RPM_SIGN_USER}

[ "x${R_BASE}" == "x/var/www/staging" ] || {
    RPM_SIGN_USER=${BUILD_USER}
    RPM_SIGN_UID=${BUILD_UID}
    #RPM_SIGN_UID=0
}
[ "x${R_BASE}" == "x/var/www/staging" ] && {
    RPM_SIGN_USER=${CICD_USER}
    RPM_SIGN_UID=${CICD_UID}
    RPM_SIGN_UID=0
}


for d in $YUM_DISTROS; do
    echo -n "$d: sign rpms..(takes long).."
    [ -z ${VERBOSE} ] || {
    echo -e "\nssh -R /run/user/${RPM_SIGN_UID}/gnupg/S.gpg-agent:/run/user/${UID}/gnupg/S.gpg-agent.extra \
        ${REMOTE} \"
        rpmsign --addsign ${R_BASE}/${d}/*rpm > /dev/null 2>&1 \"
        "
    }
    # Sign
    ssh -R /run/user/${RPM_SIGN_UID}/gnupg/S.gpg-agent:/run/user/${UID}/gnupg/S.gpg-agent.extra \
        ${REMOTE} "
        rpmsign --addsign ${R_BASE}/${d}/*rpm > /dev/null 2>&1 || {
            echo \"  -> Error signing rpms in ${d} <-\"
            echo -e \"\n    try running this:\n        ssh -R /run/user/${RPM_SIGN_UID}/gnupg/S.gpg-agent:/run/user/${UID}/gnupg/S.gpg-agent.extra ${REMOTE} \\\"gpg -K\\\" \"
            echo -e \"    If the output is empty, there is another root session open. Make sure the other root closes it\n\"
        }
        "
    # Chown back to the right user:
    ssh ${REMOTE} "
        chown ${RPM_SIGN_USER} ${R_BASE}/${d}/*rpm > /dev/null 2>&1 || echo \"Error chowning rpms back ${d}\"
        chmod 644 ${R_BASE}/${d}/*rpm > /dev/null 2>&1 || echo \"Error chmoding rpms back ${d}\"
        "


    echo -n " create-remote..."
    ssh ${REMOTE} "
        /usr/bin/createrepo_c --database ${R_BASE}/${d} > /dev/null || echo \"error with yum ssh\"
        "
    echo -n " sign-locally..."
    scp ${REMOTE}:${R_BASE}/${d}/repodata/repomd.xml $TMP > /dev/null || echo "error with yum ssh"
    gpg --detach-sign -u $KEYNAME --armor $TMP/repomd.xml
    
    echo -n " upload..."
    scp ${TMP}/repomd.xml.asc ${REMOTE}:${R_BASE}/${d}/repodata/ > /dev/null || echo "error with yum ssh"
    rm -f ${TMP}/repomd.xml*
    echo " done"
done

# Cleanup tmp
rm -rf $TMP

