#!/bin/bash
LOGS=$HOME/logs

export DIST=stretch
sudo DEPS=oidc-agent  HOME=$HOME  DIST=$DIST cowbuilder --update > $LOGS/${DIST}_update.log
export DIST=buster
sudo                  HOME=$HOME  DIST=$DIST cowbuilder --update > $LOGS/${DIST}_update.log
export DIST=bullseye
sudo                  HOME=$HOME  DIST=$DIST cowbuilder --update > $LOGS/${DIST}_update.log
export DIST=bookworm
sudo                  HOME=$HOME  DIST=$DIST cowbuilder --update > $LOGS/${DIST}_update.log
export DIST=xenial  
sudo DEPS=oidc-agent  HOME=$HOME  DIST=$DIST cowbuilder --update > $LOGS/${DIST}_update.log
export DIST=bionic  
sudo                  HOME=$HOME  DIST=$DIST cowbuilder --update > $LOGS/${DIST}_update.log

ls $LOGS/*_update.log
