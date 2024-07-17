#!/bin/bash

# eg: reanme_mz.sh "string1" "string2" files
#
if test ${#} -ne 4
then
    printf "Invalid parameter!\n"
    exit 1
fi

for i in $(ls ${3})
do
    mv -v ${i} ${i/${1}/${2}}
done
