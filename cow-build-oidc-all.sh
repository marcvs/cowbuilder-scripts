#!/bin/bash
#
LOGS=$HOME/logs
DEB_SRC_LOG=$LOGS/oidc-agent-deb-src.log
OIDC_AGENT_DIR="${HOME}/oidc-agent-deb/oidc-agent"

[ -z $1 ] && {
    echo "The version of oidc-agent must be the only parameter. Ex: 2.0.3"
    exit 1
}
VERSION=$1

echo "Building oidc-agent version $VERSION using $OIDC_AGENT_DIR"
echo "logs go to $DEB_SRC_LOG"

cd $OIDC_AGENT_DIR 
echo "Pulling changes"
pushd ./ > /dev/null
git pull
debuild -uc -us > $DEB_SRC_LOG
cd ..

FILE="oidc-agent_${VERSION}.dsc"
sudo ls -l $FILE || {
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

popd > /dev/null
