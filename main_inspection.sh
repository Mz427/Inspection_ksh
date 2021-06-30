#!/bin/bash

declare -A hosts_list

function execute_script
{
    for i in "${!hosts_list[@]}"
    do
        if test ${1} = "all_hosts"
        then
            j=${1}
        else
            j=${hosts_list[${i}]}
        fi

        if test ${j} = ${1}
        then
            #Execute base inspection script.
            if test -e base_inspection.sh
            then
                ssh -T ${hosts_list[${i}]} < base_inspection.sh
            fi

            #Execute spectify inspection script.
            if test -e ${i}".sh"
            then
                ssh -T ${OPTARG} < ${i}".sh"
            fi
        fi
    done
}

eval $(awk '! /^#/{printf "hosts_list[%s]=%s\n", $1, $2}' hosts_list.conf)

#Main
if test ${#} -gt 0
then
    while getopts n:h:v current_opt
    do
        case ${current_opt} in
            n)
                current_ip=${hosts_list[${OPTARG}]}
                execute_script ${current_ip}
            ;;
            h)
                current_ip=${OPTARG}
                execute_script ${current_ip}
            ;;
            v)
                #awk error.log
            ;;
            *)
                printf "Wrong parameter format."
            ;;
        esac
    done
else
    execute_script all_hosts
fi
