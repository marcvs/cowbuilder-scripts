#!/bin/bash

set -e

[ -z $1 ] && {
    echo "The version of oidc-agent must be the only parameter. Ex: 2.0.3"
    exit 1
}
VERSION=$1

BASE="/var/cache/pbuilder/"
GITHUB="/home/buil/github"
OIDC_AGENT=oidc-agent_${VERSION}_amd64.deb
PACKAGES="$OIDC_AGENT \
    oidc-agent_${VERSION}.dsc \
    oidc-agent_${VERSION}.tar.xz \
    oidc-agent-dbgsym_${VERSION}_amd64.deb"

DEB_DISTROS="buster stretch "
UBU_DISTROS="bionic xenial"
#DEB_REPO=/var/cache/debian-repo/debian
#UBU_REPO=/var/cache/debian-repo/ubuntu
DEB_REPO=/var/www/debian
UBU_REPO=/var/www/ubuntu

# Clean github output:
test -d $GITHUB || mkdir -p $GITHUB
test -d $GITHUB && rm -f $GITHUB/*
echo "Please be aware that this folder will be erased and recreated by
scripts" > $GITHUB/README.txt

for i in libsodium18_1.0.11-2_amd64.deb \
         $OIDC_AGENT; \
     do 
         cp $BASE/result/xenial-amd64/$i $GITHUB/xenial-$i
     done

for i in $DEB_DISTROS $UBU_DISTROS; do 
    cp $BASE/result/$i-amd64/$OIDC_AGENT $GITHUB/$i-$OIDC_AGENT
done

# copy to repo 
test -d $DEB_REPO || mkdir $DEB_REPO
test -d $UBU_REPO || mkdir $UBU_REPO

cp $BASE/result/xenial-amd64/libsodium18_1.0.11-2_amd64.deb $UBU_REPO/xenial || echo "error"

for i in $DEB_DISTROS; do 
    test -d $DEB_REPO/$i || mkdir $DEB_REPO/$i
    for p in $PACKAGES; do
        cp $BASE/result/$i-amd64/$p $DEB_REPO/$i 2> /dev/null 
    done
done
for i in $UBU_DISTROS; do 
    test -d $UBU_REPO/$i || mkdir $UBU_REPO/$i
    for p in $PACKAGES; do
        cp $BASE/result/$i-amd64/$p $UBU_REPO/$i 2> /dev/null 
    done
done

#chown -R marcus.users $DEB_REPO $UBU_REPO
#rsync -rlutopgxv --delete /var/cache/pbuilder/result/ root@cvs.fzk.de:/var/www/oidc-agent/
#rsync -rlutopgxv --delete /var/cache/debian-repo/ root@cvs.fzk.de:/var/www/debian/
