#!/bin/bash

# find md docs in update-debian-repo.sh.md
# (in the same folder as this executable)

REMOTE=root@repo.data.kit.edu
R_BASE=/var/www/
TMP=`mktemp -d`
MD_INPUT_FILE=$(cd "`dirname $0`" 2>/dev/null && pwd)/`basename $0`
# Generate index.html
echo "md input: $MD_INPUT_FILE"
[ -e ~/bin/md2html.sh ] && {
    ~/bin/md2html.sh $MD_INPUT_FILE.md > $TMP/md2html.log 2>&1
    cat /tmp/md.html > $TMP/index.html
    scp $TMP/index.html $REMOTE:/$R_BASE/ > /dev/null || echo "error with ssh"
}
#echo "TMP: $TMP"
#TMP="/var/cache/debian-repo"

DISTROS="debian/bullseye debian/buster debian/stretch ubuntu/bionic ubuntu/xenial"
DEB_REPO="$TMP/debian"
UBU_REPO="$TMP/ubuntu"
export GNUPGHOME=$HOME/.gnupg
export KEYNAME="ACDFB08FDC962044D87FF00B512839863D487A87"

cd $TMP

# Generate repo files remotely
echo -n "Generate repo files remotely "
for d in $DISTROS ; do 
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
done
echo "done"
# Sync remote repo here:
echo -n "Sign Release files "
for d in $DISTROS ; do 
    echo -n "$d "
    mkdir -p $TMP/$d
    scp $REMOTE:$R_BASE/$d/Release $TMP/$d  > /dev/null || echo "error with ssh"
    gpg --yes -abs -u $KEYNAME -o $d/Release.gpg $d/Release
    scp $TMP/$d/Release.gpg $REMOTE:$R_BASE/$d/ > /dev/null || echo "error with ssh"

done
echo "done"

## Ensure symlinks are in place
#    cd $DEB_REPO
#    test -e testing || ln -s buster/ testing
#    test -e stable  || ln -s stretch/ stable
#
#    cd $UBU_REPO
#    test -e 18.04   ||ln -s bionic/ 18.04
#    test -e 16.04   ||ln -s xenial/ 16.04


# Cleanup tmp
rm -rf $TMP
