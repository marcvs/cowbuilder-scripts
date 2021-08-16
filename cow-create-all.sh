#!/bin/bash

BASE=/var/cache/pbuilder/
# DEBIAN
export DIST=bookworm
sudo mkdir -p $BASE/$DIST-amd64/aptcache
sudo HOME=$HOME DIST=$DIST cowbuilder --create \
    --basepath /var/cache/pbuilder/${DIST}-amd64/base.cow/ \
    --distribution $DIST

export DIST=bullseye
sudo mkdir -p $BASE/$DIST-amd64/aptcache
sudo HOME=$HOME DIST=$DIST cowbuilder --create \
    --basepath /var/cache/pbuilder/${DIST}-amd64/base.cow/ \
    --distribution $DIST

export DIST=buster
sudo mkdir -p $BASE/$DIST-amd64/aptcache
sudo HOME=$HOME DIST=$DIST cowbuilder --create \
    --basepath /var/cache/pbuilder/${DIST}-amd64/base.cow/ \
    --distribution $DIST

# export DIST=stretch
# sudo mkdir -p $BASE/$DIST-amd64/aptcache
# sudo HOME=$HOME DIST=$DIST cowbuilder --create \
#     --basepath /var/cache/pbuilder/${DIST}-amd64/base.cow/ \
#     --distribution $DIST

# UBUNTU
#key for bionic:
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3B4FE6ACC0B21F32
# key for xenial: 
wget http://archive.ubuntu.com/ubuntu/project/ubuntu-archive-keyring.gpg
sudo mv ubuntu-archive-keyring.gpg /usr/share/keyrings/

export DIST=focal
sudo mkdir -p $BASE/$DIST-amd64/aptcache
sudo HOME=$HOME DIST=$DIST cowbuilder --create \
    --basepath /var/cache/pbuilder/${DIST}-amd64/base.cow/ \
    --distribution $DIST \
    --mirror http://archive.ubuntu.com/ubuntu \
    --components "main universe"

export DIST=bionic
sudo mkdir -p $BASE/$DIST-amd64/aptcache
sudo HOME=$HOME DIST=$DIST cowbuilder --create \
    --basepath /var/cache/pbuilder/${DIST}-amd64/base.cow/ \
    --distribution $DIST \
    --mirror http://archive.ubuntu.com/ubuntu \
    --components "main universe" \
    --debootstrapopts --keyring=/usr/share/keyrings/ubuntu-archive-keyring-from-nemo.gpg

export DIST=xenial
sudo mkdir -p $BASE/$DIST-amd64/aptcache
sudo HOME=$HOME DIST=$DIST cowbuilder --create \
    --basepath /var/cache/pbuilder/${DIST}-amd64/base.cow/ \
    --distribution $DIST \
    --mirror http://archive.ubuntu.com/ubuntu \
    --components "main universe" \
    --debootstrapopts --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg

#key for bionic:
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3B4FE6ACC0B21F32
