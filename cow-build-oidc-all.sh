#!/bin/bash
#
#FILE=oidc-agent_2.0.1.dsc
FILE=$1

sudo ls -l $FILE

DIST=stretch
(
echo "Building for $DIST..."
sudo                  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > buildlog-$DIST.log 2>&1
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
