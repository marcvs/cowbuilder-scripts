#!/bin/bash

set -e

LOGS="${HOME}/logs"
DEB_SRC_LOG="${LOGS}/oidc-agent-deb-src.log"
OIDC_AGENT_DIR="${HOME}/oidc-agent-deb/oidc-agent"
BRANCH="master"
BUILDTMP="${HOME}/buildtemp"

# DISTS="buster bullseye bionic focal xenial stretch"
DISTS="buster bullseye bookworm bionic focal"

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
        echo "Preparing build for $PACKAGE $BRANCH in $DIST "
        test -d $BUILDTMP || mkdir -p $BUILDTMP
        cd $BUILDTMP

        test -e $DIST && rm -rf $DIST

        # git
        mkdir -p $DIST
        cd $DIST
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
            stretch | xenial | bionic)
                # Essentiall changes Build-Depends from debhelper-13 to 12
                make bionic-debsource >> $LOG 2>&1
            ;;
            buster)
                make buster-debsource >> $LOG 2>&1
            ;;
            focal)
                make focal-debsource >> $LOG 2>&1
            ;;
            *)
                make debsource >> $LOG 2>&1
            ;;
        esac

        # Distro specific dependency specification
        case "${DIST}" in
            stretch | xenial | bionic | focal )
                DEPENDENCY_DIR="oidc-agent"
            ;;
        esac

        # cd back to $DIST dir
        cd ..

        # And start the build
        echo -e "Starting build for $DIST \t  $PACKAGE $VERSION_DEBREL (${BRANCH}) (DEPS: $DEPENDENCY_DIR)..."
        sudo DEPS=$DEPENDENCY_DIR  HOME=$HOME DIST=$DIST cowbuilder --build $FILE >> $LOG 2>&1 && {
            echo -e "    Success: $DIST"
            exit 0
        }
        echo -e "    Failed: $DIST  For details see $LOG"
    )&
done
echo -e "\nOnce the build is done you can copy the files to the repo using"
echo -e "~/cowbuilder-scripts/publish-oidc.sh ${VERSION_DEBREL} \n" 

