#!/bin/bash

# find md docs in update-debian-repo.sh.md
# (in the same folder as this executable)

REMOTE=root@repo.data.kit.edu
R_BASE=/var/www/
TMP=`mktemp -d`
#echo "TMP: $TMP"
TMP="/var/cache/debian-repo"

DISTROS="debian/buster debian/stretch ubuntu/bionic ubuntu/xenial"
DEB_REPO="$TMP/debian"
UBU_REPO="$TMP/ubuntu"
export GNUPGHOME=/home/marcus/.gnupg
export KEYNAME="ACDFB08FDC962044D87FF00B512839863D487A87"

cd $TMP

# Sync remote repo here:
echo -n "Sync from remote..... "
rsync -rlutopgx $REMOTE:$R_BASE/ .
echo "done"

# Generate repo files
echo -n "Generate repo files.. "
for d in $DISTROS ; do 
    pushd ./ > /dev/null
        cd $d

        #-- build Packages file
        apt-ftparchive packages . > Packages
        bzip2 -kf Packages

        #-- signed Release file
        apt-ftparchive release . > Release
        gpg --yes -abs -u $KEYNAME -o Release.gpg Release
    popd > /dev/null
done
echo "done"

# Ensure symlinks are in place
    cd $DEB_REPO
    test -e testing || ln -s buster/ testing
    test -e stable  || ln -s stretch/ stable

    cd $UBU_REPO
    test -e 18.04   ||ln -s bionic/ 18.04
    test -e 16.04   ||ln -s xenial/ 16.04

# Generate index.html
~/bin/md2html.sh $0.md > `dirname $DEB_REPO`/index.html

# sync back
cd $TMP
echo -n "Sync back to remote.. "
rsync -rlutopgx --delete . $REMOTE:$R_BASE/ 
echo "done"
