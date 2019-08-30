#!/bin/bash

while read file; do 
    echo "=== $file ====" >> counts.txt
    jq -r " .[] | [.protectionLevel] | @csv " $file \
        | sort \
        | tee -a >(wc -l | xargs -I@ echo "permission total: @" >> counts.txt) \
        | uniq -c \
        | sort -n \
        | tee -a counts.txt \
        | wc -l \
        | xargs -I@ echo "total: @" \
            >> counts.txt
done < <(ls -1 *.json)
