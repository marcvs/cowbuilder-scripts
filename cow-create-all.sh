#!/bin/bash

BASE=/var/cache/pbuilder/
# DEBIAN
export DIST=buster
sudo mkdir $BASE/$DIST-amd64
sudo HOME=$HOME DIST=$DIST cowbuilder --create \
    --basepath /var/cache/pbuilder/${DIST}-amd64/base.cow/ \
    --distribution $DIST

export DIST=stretch
sudo mkdir $BASE/$DIST-amd64
sudo HOME=$HOME DIST=$DIST cowbuilder --create \
    --basepath /var/cache/pbuilder/${DIST}-amd64/base.cow/ \
    --distribution $DIST

# UBUNTU
#key for bionic:
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3B4FE6ACC0B21F32
# key for xenial: 
wget http://archive.ubuntu.com/ubuntu/project/ubuntu-archive-keyring.gpg
sudo mv ubuntu-archive-keyring.gpg /usr/share/keyrings/

export DIST=bionic
sudo mkdir $BASE/$DIST-amd64
sudo HOME=$HOME DIST=$DIST cowbuilder --create \
    --basepath /var/cache/pbuilder/${DIST}-amd64/base.cow/ \
    --distribution $DIST \
    --mirror http://archive.ubuntu.com/ubuntu \
    --components "main universe" \
    --debootstrapopts --keyring=/usr/share/keyrings/ubuntu-archive-keyring-from-nemo.gpg

export DIST=xenial
sudo mkdir $BASE/$DIST-amd64
sudo HOME=$HOME DIST=$DIST cowbuilder --create \
    --basepath /var/cache/pbuilder/${DIST}-amd64/base.cow/ \
    --distribution $DIST \
    --mirror http://archive.ubuntu.com/ubuntu \
    --components "main universe" \
    --debootstrapopts --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg

#key for bionic:
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3B4FE6ACC0B21F32
