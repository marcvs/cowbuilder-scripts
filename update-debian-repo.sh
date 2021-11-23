#!/bin/bash

# find md docs in update-debian-repo.sh.md
# (in the same folder as this executable)

REMOTE=root@repo.data.kit.edu
R_BASE=/var/www/
TMP=`mktemp -d`
MD_INPUT_FILE=$(cd "`dirname $0`" 2>/dev/null && pwd)/`basename $0`.md
YUM_REPO_PUBKEY=$(cd "`dirname $0`" 2>/dev/null && pwd)/repo-data-kit-edu-key.gpg
YUM_REPO_CENTOS7=$(cd "`dirname $0`" 2>/dev/null && pwd)/data-kit-edu-centos7.repo
YUM_REPO_CENTOS8=$(cd "`dirname $0`" 2>/dev/null && pwd)/data-kit-edu-centos8.repo
YUM_REPO_FEDORA34=$(cd "`dirname $0`" 2>/dev/null && pwd)/data-kit-edu-fedora34.repo


DISTROS="debian/bookworm debian/bullseye debian/buster ubuntu/hirsute ubuntu/focal ubuntu/bionic"
YUM_DISTROS="centos/7 centos/8 fedora/34"

export GNUPGHOME=$HOME/.gnupg
export KEYNAME="ACDFB08FDC962044D87FF00B512839863D487A87"


usage(){
    echo "--distro <distro>/<release>, e.g.: debian/devel, default: all"
    exit 0
}
while [ $# -gt 0 ]; do
    case "$1" in
    -h|--help)          usage               exit 0                ;;
    --distro)           DISTROS=${2} ; YUM_DISTROS=""             shift ;;
    --yumdistro)        YUM_DISTROS=${2} ; DISTROS=""             shift ;;
    esac
    shift
done

AUX_FILES="$YUM_REPO_PUBKEY $YUM_REPO_CENTOS7 $YUM_REPO_CENTOS8"

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
#echo "pandoc -f gfm -t html $MD_INPUT_FILE   >> $OUTPUT_FILE"
pandoc -f gfm -t html $MD_INPUT_FILE >> $OUTPUT_FILE
scp $OUTPUT_FILE $REMOTE:/$R_BASE/ > /dev/null || echo "error with ssh"


# copy AUX_FILES
for i in $AUX_FILES; do 
    scp $i $REMOTE:/$R_BASE/ > /dev/null || echo "error copying AUX_FILES"
done

echo " done"

cd $TMP

## Generate repo files remotely
echo "Update deb Repos:"
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
    scp $TMP/$d/Release.gpg $REMOTE:$R_BASE/$d/ > /dev/null || echo "error with ssh"
    echo " done"
done

#########################################################################
#########################################################################
# YUM REPOS

echo -e "\nUpdating yum Repos:"
scp ${YUM_REPO_PUBKEY} ${REMOTE}:${R_BASE} > /dev/null || echo "error with yum ssh"

for d in $YUM_DISTROS; do
    echo -n "$d: create-remote..."
    ssh ${REMOTE} "
        /usr/bin/createrepo_c --database ${R_BASE}/${d} > /dev/null || echo \"error with yum ssh\"
        "
    scp ${REMOTE}:${R_BASE}/${d}/repodata/repomd.xml $TMP > /dev/null || echo "error with yum ssh"
    gpg --detach-sign -u $KEYNAME --armor $TMP/repomd.xml
    
    echo -n " sign-locally..."
    scp ${TMP}/repomd.xml.asc ${REMOTE}:${R_BASE}/${d}/repodata/ > /dev/null || echo "error with yum ssh"
    rm -f ${TMP}/repomd.xml*
    echo " done"
done

# Cleanup tmp
rm -rf $TMP

