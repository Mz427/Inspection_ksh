#!/bin/bash

if test $(ps -ef | grep 'java' | grep -v 'grep' | wc -l) -eq 2
then
    printf "idsysapp precess: OK.\n"
else
    printf "idsysapp WARNING: no java process.\n"
fi
