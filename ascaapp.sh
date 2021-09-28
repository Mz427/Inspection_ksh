#!/bin/bash

if test -n "$(ps -ef | grep 'java' | grep -v 'grep')"
then
    printf "ascaapp precess: OK.\n"
else
    printf "ascaapp WARNING: no java process.\n"
fi
