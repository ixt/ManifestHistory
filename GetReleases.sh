#!/bin/bash

URL="https://api.github.com/repos/aosp-mirror/platform_frameworks_base/tags?page="

RANGE="26"

for i in $(seq 1 $RANGE); do
    wget -o $i.json $URL$i 
done
