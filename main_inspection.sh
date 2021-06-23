#!/bin/ksh

declare -A hosts_list

function execute_script
{
    for i in ${!hosts_list[@]}
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

eval $(awk 'NR > 1{printf "hosts_list[%s]=%s\n", $1, $2}' hosts_list.conf)

#Main
if test ${#} gt 0
then
    while getops n:h:v current_opt
    do
        case ${current_opt} in
            n)
                execute_script ${OPTARG} host_name
            ;;
            h)
                execute_script ${OPTARG} ip
            ;;
            v)
                #awk error.log
            ;;
            *)
                #print error
            ;;
        esac
    done
else
    execute_script
fi
