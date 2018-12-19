#!/bin/bash
#
#FILE=oidc-agent_2.0.1.dsc
#FILE_23="${1}_libsodium23"
#FILE_18="${1}_libsodium18"
VERSION=$1
OIDC_AGENT_DIR="${HOME}/oidc-agent-deb/oidc-agent"
(cd $OIDC_AGENT_DIR && debuild -uc -us)
FILE="oidc-agent_${VERSION}.dsc"

sudo ls -l $FILE

DIST=stretch
(
echo "Building for $DIST..."
sudo DEPS=oidc-agent  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > buildlog-$DIST.log 2>&1
echo "   $DIST: $?"
)&

DIST=buster
(
echo "Building for $DIST..."
sudo                  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > buildlog-$DIST.log 2>&1
echo "   $DIST: $?"
)&

DIST=xenial
(
echo "Building for $DIST..."
sudo DEPS=oidc-agent  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > buildlog-$DIST.log 2>&1
echo "   $DIST: $?"
)&

DIST=bionic
(
echo "Building for $DIST..."
sudo                  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > buildlog-$DIST.log 2>&1
echo "   $DIST: $?"
)&
