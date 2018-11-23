#!/bin/bash
#
FILE=oidc-agent_2.0.0.dsc

sudo                  HOME=$HOME DIST=stretch cowbuilder --update
sudo                  HOME=$HOME DIST=buster  cowbuilder --update
sudo DEPS=oidc-agent  HOME=$HOME DIST=xenial  cowbuilder --update
sudo                  HOME=$HOME DIST=bionic  cowbuilder --update
