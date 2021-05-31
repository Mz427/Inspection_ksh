#!/bin/ksh

declare -A hosts_list

eval $(awk 'NR > 1{printf "hosts_list[%s]=%s\n", $1, $2}' hosts_list.conf)

if test ${#} gt 0
then
    while getops n:h:v current_opt
    do
        case ${current_opt} in
            n)
            ;;
            h)
            ;;
            v)
            ;;
            *)
            ;;
        esac
    done
else
    for i in ${!hosts_list[@]}
    do
        #Execute base inspection script.
        if test -e base_inspection.sh
            ssh -T ${hosts_list[${i}]} < base_inspection.sh
        fi

        #Execute spectify inspection script.
        if test -e ${i}".sh"
            ssh -T ${hosts_list[${i}]} < ${i}"i.sh"
        fi
    done
fi
