#!/bin/ksh

function database_status
{
}

function ascaapp_check
{
    printf "############################################################################################\n"
    printf "#                                     ascaapp                                              #\n"
    printf "############################################################################################\n"

    if test $(ps -ef | grep 'java' | grep -v 'grep' | wc -l) -eq 2
    then
        printf "ascaapp precess: OK.\n"
    else
        printf "ascaapp WARNING: no java process.\n"
    fi
}

function ASCA_check
{
    printf "############################################################################################\n"
    printf "#                                        ASCA                                              #\n"
    printf "############################################################################################\n"

    database_status
}

function idsysapp_check
{
    printf "############################################################################################\n"
    printf "#                                        idsysapp                                          #\n"
    printf "############################################################################################\n"

    if test $(ps -ef | grep 'java' | grep -v 'grep' | wc -l) -eq 2
    then
        printf "idsysapp precess: OK.\n"
    else
        printf "idsysapp WARNING: no java process.\n"
    fi
}

function IDSYS_check
{
    printf "############################################################################################\n"
    printf "#                                        IDSYS                                             #\n"
    printf "############################################################################################\n"

    database_status
}

awk '' hosts_list.conf

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
    for i in ${!hosts_list[*]}
        ssh -T ${hosts_list[${i}]} base_check
        ssh $u@$addr 'cat | bash /dev/stdin' "$@" < "$scriptfile"
        hosts_list(i)
fi
