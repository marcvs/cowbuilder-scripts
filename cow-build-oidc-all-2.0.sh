#!/bin/bash

set -e

LOGS="${HOME}/logs"
DEB_SRC_LOG="${LOGS}/oidc-agent-deb-src.log"
OIDC_AGENT_DIR="${HOME}/oidc-agent-deb/oidc-agent"
BRANCH="master"
BUILDTMP="${HOME}/buildtemp"

DISTS="buster bullseye bionic focal"

usage(){
    echo "-b, --branch <branch>"
    exit 0
}
while [ $# -gt 0 ]; do
    case "$1" in
    -h|--help)          usage        exit 0                ;;
    -b|--branch)        BRANCH=${2} ;               shift ;;
    *)                  usage ;; 
    esac
    shift
done

# maybe can be generalised at some point:
PACKAGE="oidc-agent"
PACKAGE_GIT="https://github.com/indigo-dc/oidc-agent.git"


for DIST in $DISTS; do
    (
        LOG=$LOGS/buildlog-$DIST.log
        date > $LOG
        echo "Preparing build for $PACKAGE $BRANCH in $DIST: "
        test -d $BUILDTMP || mkdir -p $BUILDTMP
        cd $BUILDTMP

        test -e $DIST && rm -rf $DIST

        # git
        mkdir -p $DIST/oidc-agent
        cd $DIST/oidc-agent
        git clone $PACKAGE_GIT >> $LOG 2>&1
        cd $PACKAGE
        git co $BRANCH >> $LOG 2>&1
        git pull >> $LOG 2>&1

        # debian source package and stuff
        VERSION_DEBREL=`head -n 1 debian/changelog | awk -F\) '{ print $1 }' | awk -F\( '{ print $2 }'`
        FILE=`head -n 1 debian/changelog | awk -F\) '{ print $1 }' |sed s/\ \(/_/`".dsc"
        # echo -e "\nBuilding ${PACKAGE} version ${VERSION_DEBREL} from branch "${BRANCH}" for $"DIST"\n"

        # Distro specific debian source file creation
        case "${DIST}" in
            bionic)
                # Essentiall changes Build-Depends from debhelper-13 to 12
                make ubuntu-bionic-source >> $LOG 2>&1
            ;;
            *)
                make debsource >> $LOG 2>&1
            ;;
        esac
        cd ..

        # And start the build
        echo -e "Starting build for $DIST \t  $PACKAGE $VERSION_DEBREL (${BRANCH}) ..."
        sudo DEPS=oidc-agent  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > $LOGS/buildlog-$DIST.log >> $LOG 2>&1
        echo "    Done $DIST: $?"
    )&
done

# ----------------------------------------------------------------------------------------
exit 0

cd $OIDC_AGENT_DIR 
echo "Pulling changes"
pushd ./ > /dev/null
git co $BRANCH
git pull


VERSION_DEBREL=`head -n 1 debian/changelog | awk -F\) '{ print $1 }' | awk -F\( '{ print $2 }'`
FILE=`head -n 1 debian/changelog | awk -F\) '{ print $1 }' |sed s/\ \(/_/`".dsc"

echo -e "\nBuilding oidc-agent version $VERSION_DEBREL from branch "${BRANCH}" using $OIDC_AGENT_DIR\n"

echo "git stage done; now going to debuild"

# create debian source package:
case "${DIST}" in
    bionic)
        make ubuntu-bionic-source> $DEB_SRC_LOG 2>&1
    ;;
    *)
        make debsource > $DEB_SRC_LOG 2>&1
    ;;
esac
#debuild -uc -us > $DEB_SRC_LOG
cd ..
sudo ls -l $FILE > /dev/null || {
    echo ".dsc file not found. I was expecting: $FILE"
    exit 1
}

# DIST=stretch
# (
# echo "Building for $DIST..."
# sudo DEPS=oidc-agent  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > $LOGS/buildlog-$DIST.log 2>&1
# echo "   $DIST: $?"
# )&

DIST=buster
(
echo "Building for $DIST..."
sudo DEPS=oidc-agent  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > $LOGS/buildlog-$DIST.log 2>&1
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
sudo DEPS=oidc-agent  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > $LOGS/buildlog-$DIST.log 2>&1
echo "   $DIST: $?"
)&

DIST=focal
(
echo "Building for $DIST..."
sudo DEPS=oidc-agent  HOME=$HOME DIST=$DIST cowbuilder --build $FILE > $LOGS/buildlog-$DIST.log 2>&1
echo "   $DIST: $?"
)&

wait
popd > /dev/null
