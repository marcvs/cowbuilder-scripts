#!/bin/bash

export DIST=stretch
sudo                  HOME=$HOME  DIST=$DIST cowbuilder --update > ${DIST}_update.log
export DIST=buster
sudo                  HOME=$HOME  DIST=$DIST cowbuilder --update > ${DIST}_update.log
export DIST=bullseye
sudo                  HOME=$HOME  DIST=$DIST cowbuilder --update > ${DIST}_update.log
export DIST=xenial  
sudo DEPS=oidc-agent  HOME=$HOME  DIST=$DIST cowbuilder --update > ${DIST}_update.log
export DIST=bionic  
sudo                  HOME=$HOME  DIST=$DIST cowbuilder --update > ${DIST}_update.log

ls *_update.log
