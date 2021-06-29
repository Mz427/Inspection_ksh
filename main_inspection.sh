#!/bin/bash

declare -A hosts_list

function execute_script
{
    for i in "${!hosts_list[@]}"
    do
        #Execute base inspection script.
        if test -e base_inspection.sh
        then
            ssh -T ${hosts_list[${i}]} < base_inspection.sh
        fi

        #Execute spectify inspection script.
        if test -e ${i}".sh"
        then
            ssh -T ${hosts_list[${i}]} < ${i}".sh"
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
                if test "${hosts_list[${OPTARG}]}"
                then
                    printf "Can't find host: %s.\n" ${OPTARG}
                else
                    #Execute base inspection script.
                    if test -e base_inspection.sh
                    then
                        ssh -T ${hosts_list[${OPTARG}]} < base_inspection.sh
                    fi

                    #Execute spectify inspection script.
                    if test -e ${OPTARG}".sh"
                    then
                        ssh -T ${hosts_list[${OPTARG}]} < ${OPTARG}".sh"
                    fi
                fi
            ;;
            h)
                for i in ${!hosts_list[@]}
                do
                    if test ${hosts_list[${i}]} = ${OPTARG}
                    then
                        #Execute base inspection script.
                        if test -e base_inspection.sh
                        then
                            ssh -T ${OPTARG} < base_inspection.sh
                        fi

                        #Execute spectify inspection script.
                        if test -e ${i}".sh"
                        then
                            ssh -T ${OPTARG} < ${i}".sh"
                        fi
                    fi
                done
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
    execute_script
fi
