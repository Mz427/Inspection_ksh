#!/bin/bash

if test $(ps -ef | grep 'java' | grep -v 'grep' | wc -l) -eq 2
then
    printf "ascaapp precess: OK.\n"
else
    printf "ascaapp WARNING: no java process.\n"
fi
