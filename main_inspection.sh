#!/bin/bash

TRUE=0
FALSE=1
declare -A hosts_list

function execute_script
{
    wrong_ip=${TRUE}

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
            wrong_ip=${FALSE}
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

    if test ${wrong_ip} -eq ${TRUE}
    then
        printf "Can't find host: %s.\n" ${1}
    fi
}

eval $(awk '! /^#/{printf "hosts_list[%s]=%s\n", $1, $2}' hosts_list.conf)

#Main
if test ${#} -eq 2
then
    while getopts n:h:v current_opt
    do
        case ${current_opt} in
            n)
                current_ip=${hosts_list[${OPTARG}]}
                if test ${current_ip}
                then
                    execute_script ${current_ip}
                else
                    printf "Can't find host: %s.\n" ${OPTARG}
                fi
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
