#!/bin/bash

REPOBASE="build@repo.data.kit.edu:/var/www"

#rpmsign --addsign */*rpm

for i in * ; do 
    DIST=`echo $i | cut -d_ -f 1`
    REL=`echo $i | cut -d_ -f 2`

    echo -e "$DIST - $REL"
    scp -q $i/*.deb $i/*.rpm $i/*.gz $i/*.xz $i/*.gz $i/*.changes $i/*.dsc \
        ${REPOBASE}/${DIST}/${REL} > /dev/null 2>&1
    #ls -l $i; done
done
