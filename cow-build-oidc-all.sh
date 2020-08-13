#!/bin/bash
#
LOGS=$HOME/logs
DEB_SRC_LOG=$LOGS/oidc-agent-deb-src.log
OIDC_AGENT_DIR="${HOME}/oidc-agent-deb/oidc-agent"
BRANCH="master"
VERSION=""
# FIXME: DEBIAN_RELEASE is hardcoded for now
DEBIAN_RELEASE="1"

usage(){
    echo "-v, --version  <version>"
    echo "-b, --branch <branch>"
    exit 0
}
while [ $# -gt 0 ]; do
    case "$1" in
    -h|--help)          usage        exit 0                ;;
    -v|--version)       VERSION=${2} ;               shift ;;
    -b|--branch)        BRANCH=${2} ;               shift ;;
    *)                  usage ;; 
    esac
    shift
done

echo "logs go to $DEB_SRC_LOG"

cd $OIDC_AGENT_DIR 
echo "Pulling changes"
pushd ./ > /dev/null
git pull
git co $BRANCH

[ -z ${VERSION} ] && {
    VERSION=`cat VERSION`
    echo "Autosetting Version to $VERSION"
    #echo "The version of oidc-agent must be specifiec Ex: -v 2.0.3"
    #exit 1
}

echo -e "\nBuilding oidc-agent version $VERSION-$DEBIAN_RELEASE from branch "${BRANCH}" using $OIDC_AGENT_DIR\n"

echo "git stage done; now going to debuild"

# create debian source package:
make debsource > $DEB_SRC_LOG 2>&1
#debuild -uc -us > $DEB_SRC_LOG
cd ..

FILE="oidc-agent_${VERSION}-${DEBIAN_RELEASE}.dsc"
sudo ls -l $FILE > /dev/null || {
    echo ".dsc file not found. I was expecting: $FILE"
    exit 1
}

DIST=stretch
(
echo "Building for $DIST..."
sudo DEPS=oidc-agent  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > $LOGS/buildlog-$DIST.log 2>&1
echo "   $DIST: $?"
)&

DIST=buster
(
echo "Building for $DIST..."
sudo                  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > $LOGS/buildlog-$DIST.log 2>&1
echo "   $DIST: $?"
)&

DIST=bullseye
(
echo "Building for $DIST..."
sudo                  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > $LOGS/buildlog-$DIST.log 2>&1
echo "   $DIST: $?"
)&

DIST=xenial
(
echo "Building for $DIST..."
sudo DEPS=oidc-agent  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > $LOGS/buildlog-$DIST.log 2>&1
echo "   $DIST: $?"
)&

DIST=bionic
(
echo "Building for $DIST..."
sudo                  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > $LOGS/buildlog-$DIST.log 2>&1
echo "   $DIST: $?"
)&

wait
popd > /dev/null
