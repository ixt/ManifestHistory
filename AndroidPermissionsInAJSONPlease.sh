#!/bin/bash
# A Script that takes the AndroidManifest file and boils the contents over a
# medium vim to get a JSON db of comments and carious other data from the XML 
CURDIR=$(dirname $0)

permissionCount=$(grep "<permission " ${1} | wc -l)
MACRO=$(mktemp)

cat <<EOF >$MACRO
qy/manifest>?<permission ?<!--V/\/>xGpggq${permissionCount}@yggV/manifest>x
:%s/<p>//ggg
:%s/@[a-zA-Z]*//ggg
:%s/^[ ]*//ggg
:g/android:description/dgg
:g/android:label/dgg
:g/android.label/dgg
:g/android:permissionGroup/dgg
:%s/android://ggg
:%s/<permission /},{\r/ggg
:%s/\/>//ggg
Gqp?<!--V/-->J^kq${permissionCount}@p
:%s/{[^#]*#\([a-zA-Z_0-9]*\)}/\1/ggg
:%s/[^,]{//ggg
:%s/}[^,]//ggg
:%s/<a[^"]*//ggg
:%s/\/a>//ggg
:%s/<[^>!]*>//ggg
:%s/"/'/ggg
:%s/='/:"/ggg
:%s/'[ ]*$/"/ggg
:%s/^name/"name"/ggg
:%s/^protectionLevel/"protectionLevel"/ggg
:%s/^permissionFlags/"permissionFlags"/ggg
:%s/<!--[ ]*/"description":"/ggg
:%s/[ ]*-->/"/ggg
:%s/[ ]*$//ggg
:%s/"$/",/ggg
:%s/[^\^]}/}\r/g
:%s/}$/\r},{/ggg
:g/^,{$/dgg
Gqq?"description":ddpq${permissionCount}@q
ggddO[{Go}]:wq! temp.json
EOF

vim $1 -s $MACRO
cat temp.json \
    | tr -d '\r\n' \
    | sed -e 's/,}/}/g' -e 's/""/","/g' \
    | sed -e 's/""/","/g' \
    | sed -e 's/\({"description":"[^"]*"\)},{/\1,/g' \
        > permissionsDatabase-${1//.xml/}.json 

sed -i -e "s/|/ /g" permissionsDatabase-${1//.xml/}.json

rm temp.json $MACRO
