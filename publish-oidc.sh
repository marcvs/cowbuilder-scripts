#!/bin/bash

set -e

[ -z $1 ] && {
    echo "The version of oidc-agent must be the only parameter. Ex: 2.0.3"
    exit 1
}
VERSION=$1
VERSION_NO_RELEASE=`echo ${VERSION} | cut -d - -f 1`
echo "Version_NO_RELEASE: $VERSION_NO_RELEASE"

BASE="/var/cache/pbuilder/"
GITHUB="/home/build/github"
OIDC_AGENT=oidc-agent_${VERSION}_amd64.deb
LIBOIDC_AGENT=liboidc-agent4_${VERSION}_amd64.deb
LIBOIDC_AGENTDEV=liboidc-agent-dev_${VERSION}_amd64.deb

PACKAGES="
oidc-agent_${VERSION}.dsc \
liboidc-agent4_${VERSION}_amd64.deb \
liboidc-agent-dev_${VERSION}_amd64.deb \
oidc-agent_${VERSION}_amd64.buildinfo \
oidc-agent_${VERSION}_amd64.changes \
oidc-agent_${VERSION}_amd64.deb \
oidc-agent_${VERSION}.debian.tar.xz \
oidc-agent_${VERSION_NO_RELEASE}.orig.tar.gz \
oidc-agent-cli_${VERSION}_amd64.deb \
oidc-agent-desktop_${VERSION}_all.deb
"

PACKAGES_FOR_GITHUB="
liboidc-agent4_${VERSION}_amd64.deb \
liboidc-agent-dev_${VERSION}_amd64.deb \
oidc-agent_${VERSION}_amd64.deb \
oidc-agent-cli_${VERSION}_amd64.deb \
oidc-agent-desktop_${VERSION}_all.deb
"

PACKAGES_DBG="
oidc-agent-cli-dbgsym_${VERSION}_amd64.deb
liboidc-agent4-dbgsym_${VERSION}_amd64.deb
"


DEB_DISTROS="bookworm bullseye buster"
UBU_DISTROS="focal bionic"
#DEB_REPO=/var/cache/debian-repo/debian
#UBU_REPO=/var/cache/debian-repo/ubuntu
DEB_REPO=/var/www/debian
UBU_REPO=/var/www/ubuntu

# Clean github output:
test -d $GITHUB || mkdir -p $GITHUB
test -d $GITHUB && rm -f $GITHUB/*
echo "Please be aware that this folder will be erased and recreated by
scripts" > $GITHUB/README.txt

# copy to github
# cp $BASE/deps/xenial-amd64/oidc-agent/libsodium18_1.0.11-2_amd64.deb $GITHUB/xenial-libsodium18_1.0.11-2_amd64.deb

for i in $DEB_DISTROS $UBU_DISTROS; do 
    for package in $PACKAGES_FOR_GITHUB; do 
        cp $BASE/result/$i-amd64/$OIDC_AGENT $GITHUB/$i-$OIDC_AGENT
        cp $BASE/result/$i-amd64/$LIBOIDC_AGENT $GITHUB/$i-$LIBOIDC_AGENT
        cp $BASE/result/$i-amd64/$LIBOIDC_AGENTDEV $GITHUB/$i-$LIBOIDC_AGENTDEV
    done
done
echo "github output done. See '$GITHUB'"

# copy to repo 
test -d $DEB_REPO || mkdir $DEB_REPO
test -d $UBU_REPO || mkdir $UBU_REPO

# cp $BASE/deps/xenial-amd64/oidc-agent/libsodium18_1.0.11-2_amd64.deb $UBU_REPO/xenial 

for i in $DEB_DISTROS; do 
    test -d $DEB_REPO/$i || mkdir $DEB_REPO/$i
    for p in $PACKAGES $PACKAGES_DBG; do
        cp $BASE/result/$i-amd64/$p $DEB_REPO/$i #2> /dev/null 
    done
done
for i in $UBU_DISTROS; do 
    test -d $UBU_REPO/$i || mkdir $UBU_REPO/$i
    for p in $PACKAGES; do
        cp $BASE/result/$i-amd64/$p $UBU_REPO/$i #2> /dev/null 
    done
done
echo "debian output done. To really update the repo, the package and release files still have to be created _and_signed_."

#chown -R marcus.users $DEB_REPO $UBU_REPO
#rsync -rlutopgxv --delete /var/cache/pbuilder/result/ root@cvs.fzk.de:/var/www/oidc-agent/
#rsync -rlutopgxv --delete /var/cache/debian-repo/ root@cvs.fzk.de:/var/www/debian/
