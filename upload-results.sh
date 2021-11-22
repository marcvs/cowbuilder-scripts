#!/bin/bash

REPOBASE="build@repo.data.kit.edu:/var/www"

#rpmsign --addsign */*rpm

VERSION="NONE"

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
    DIST=`echo $i | cut -d_ -f 1`
    DIST_REL=`echo $i | cut -d_ -f 2`

    echo -e "\n$DIST - $DIST_REL"
    PKG_VER=`echo $VERSION | awk -F- '{ print $1 }' `
    PKG_REL=`echo $VERSION | awk -F- '{ print $2 }' `

    [ -z $PKG_REL ] && { 
        PKG_REL=1
    }

    VERSION="${PKG_VER}-${PKG_REL}"
    #echo PKG_VER: $PKG_VER
    #echo PKG_REL: $PKG_REL
    #echo VERSION: $VERSION

    #echo scp -q $i/*_${VERSION}*.deb $i/*-${VERSION}*.rpm $i/*.gz $i/*.xz $i/*.changes $i/*.dsc \
    #    ${REPOBASE}/${DIST}/${REL}
    scp -q $i/*_${VERSION}*.deb $i/*-${VERSION}*.rpm $i/*_${VERSION}.xz $i/*_${VERSION}.changes $i/*_${VERSION}.dsc \
        ${REPOBASE}/${DIST}/${REL}
    #ls -l $i; done
done
