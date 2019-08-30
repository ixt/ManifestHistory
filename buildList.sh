#!/bin/bash
TEMP=$(mktemp)
IFS=',' 
while read -a line; do
    SHA=${line[1]//\"/}
    NAME=${line[0]//\"/}
    echo $NAME
    pushd ../../Pkgs/platform_frameworks_base/core/res/
        git reset --hard $SHA
        cp AndroidManifest.xml $TEMP
    popd
    cp $TEMP AndroidManifest/$NAME.xml
done < tags.csv
rm $TEMP
