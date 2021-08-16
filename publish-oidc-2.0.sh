#!/bin/bash

set -e

[ -z $1 ] && {
    echo "The version of oidc-agent must be the only parameter. Ex: 2.0.3"
    exit 1
}
VERSION=$1

BASE="/var/cache/pbuilder/"
GITHUB="/home/build/github"
OIDC_AGENT=oidc-agent_${VERSION}_amd64.deb
OIDC_AGENT_CLI=oidc-agent-cli_${VERSION}_amd64.deb
OIDC_AGENT_DESKTOP=oidc-agent-desktop_${VERSION}_amd64.deb
LIBOIDC_AGENT=liboidc-agent4_${VERSION}_amd64.deb
LIBOIDC_AGENTDEV=liboidc-agent-dev_${VERSION}_amd64.deb
# OIDC_AGENT_SERVER=oidc-agent-server_${VERSION}_amd64.deb

    # $OIDC_AGENT_SERVER \
PACKAGES="\
    oidc-agent_${VERSION}.dsc \
    oidc-agent_${VERSION}.debian.tar.xz \
    $OIDC_AGENT \
    $OIDC_AGENT_CLI \
    $OIDC_AGENT_DESKTOP \
    $LIBOIDC_AGENT \
    $LIBOIDC_AGENTDEV "
PACKAGES_DBG="
    oidc-agent-cli-dbgsym_${VERSION}_amd64.deb \
    liboidc-agent4-dbgsym_${VERSION}_amd64.deb "

DEB_DISTROS="bookworm bullseye buster"
UBU_DISTROS="focal bionic"
#DEB_REPO=/var/cache/debian-repo/debian
#UBU_REPO=/var/cache/debian-repo/ubuntu
DEB_REPO=/var/www/debian
UBU_REPO=/var/www/ubuntu

usage(){
    echo "Copy files to the appropriate locations on the webserver"
    exit 0
}
while [ $# -gt 0 ]; do
    case "$1" in
    -h|--help)          usage               exit 0                ;;
    esac
    shift
done


# Clean github output:
test -d $GITHUB || mkdir -p $GITHUB
test -d $GITHUB && rm -f $GITHUB/*
echo "Please be aware that this folder will be erased and recreated by
scripts" > $GITHUB/README.txt

# copy to github
# cp $BASE/deps/xenial-amd64/oidc-agent/libsodium18_1.0.11-2_amd64.deb $GITHUB/xenial-libsodium18_1.0.11-2_amd64.deb

for i in $DEB_DISTROS $UBU_DISTROS; do 
    cp $BASE/result/$i-amd64/$OIDC_AGENT $GITHUB/$i-$OIDC_AGENT
    cp $BASE/result/$i-amd64/$OIDC_AGENT_CLI $GITHUB/$i-$OIDC_AGENT_CLI
    cp $BASE/result/$i-amd64/$OIDC_AGENT_DESKTOP $GITHUB/$i-$OIDC_AGENT_DESKTOP
    cp $BASE/result/$i-amd64/$LIBOIDC_AGENT $GITHUB/$i-$LIBOIDC_AGENT
    cp $BASE/result/$i-amd64/$LIBOIDC_AGENTDEV $GITHUB/$i-$LIBOIDC_AGENTDEV
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
