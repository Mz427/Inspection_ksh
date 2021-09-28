#!/bin/bash

current_host=$(uname -n)

if test -n "$(ps -ef | grep 'java' | grep -v 'grep')"
then
    printf "%s precess: OK.\n" ${current_host}
else
    printf "%s WARNING: no java process.\n" ${current_host}
fi
