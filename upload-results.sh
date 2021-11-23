#!/bin/bash

REPOBASE="build@repo.data.kit.edu:/var/www"

#rpmsign --addsign */*rpm

VERSION="NONE"
VERBOSE="NOPE"

usage() {
    echo "
    -h|--help           usage
    -v|--version        Specify specific version (e.g. 4.3.2 or 4.3.2-2) 
    "
    exit 0
}

while [ $# -gt 0 ]; do
    case "$1" in
    -h|--help)          usage                           exit 0          ;;
    -v|--version)       VERSION=$2;                                shift;;
    --verbose)          VERBOSE="SHURE"                                 ;;
    esac
    shift
done


# Sanity Checks

CUR_DIR=`basename \`pwd\``
[ "x${CUR_DIR}" == "xresults" ] || {
    echo -e "\nmust be run from within a results dir\n"
    exit 1
}


[ "x${VERSION}" == "xNONE" ] && { 
    echo -e "\nPlease specify version to upload using -v\n"
    usage
    exit 2
}


for i in * ; do 
    DIST_NAM=`echo $i | cut -d_ -f 1`
    DIST_REL=`echo $i | cut -d_ -f 2`

    echo -e "\n$DIST_NAM_$DIST_REL"
    PKG_VER=`echo $VERSION | awk -F- '{ print $1 }' `
    PKG_REL=`echo $VERSION | awk -F- '{ print $2 }' `

    [ -z $PKG_REL ] && { 
        PKG_REL=1
    }

    VERSION="${PKG_VER}-${PKG_REL}"
    #echo PKG_VER: $PKG_VER
    #echo PKG_REL: $PKG_REL
    #echo VERSION: $VERSION
    #echo DIST_NAM:$DIST_NAM
    #echo DIST_REL:$DIST_REL

    #echo scp -q $i/*_${VERSION}*.deb $i/*-${VERSION}*.rpm $i/*.gz $i/*.xz $i/*.changes $i/*.dsc \
    #    ${REPOBASE}/${DIST}/${REL}
    for FILE in $i/*_${VERSION}*.deb $i/*-${VERSION}*.rpm $i/*_${VERSION}.xz $i/*_${VERSION}.changes $i/*_${VERSION}.dsc; do 
        [ -e $FILE ] && {
            RV="ok"
            scp -p -q $FILE ${REPOBASE}/${DIST_NAM}/${DIST_REL} 2> /dev/null || {
                RV="fail"
            }
            [ "x$VERBOSE" == "xNOPE" ] || { 
                echo scp -p -q $FILE ${REPOBASE}/${DIST_NAM}/${DIST_REL} 2> /dev/null
            }
            [ "x$VERBOSE" == "xNOPE" ] && { 
                echo "$FILE: $RV"
            }
        }
    [ "x$VERBOSE" == "xNOPE" ] || { 
        [ -e $FILE ] || {
            echo "$FILE: Skipped"
        }
}
    done
done
