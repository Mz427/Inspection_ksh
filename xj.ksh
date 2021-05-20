#!/bin/ksh

function base_check
{
    temp_file=$(mktemp)
    mount
    df -h | tee ${temp_file}
    awk
    free -m | tee ${temp_file}
    awk
    ping 10.
    awk
    last | grep 'reboot' | tee ${temp_file}
    #reboot   system boot  2.6.18-128.el5   Wed May 12 07:57         (7+02:25)
}

function database_status
{
}

function ascaapp_check
{
    printf "############################################################################################\n"
    printf "#                                     ascaapp                                              #\n"
    printf "############################################################################################\n"
    
    if test $(ps -ef | grep java | wc -l) st 2
    then
        printf "ascaapp warning!" 
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

    if test $(ps -ef | grep java | wc -l) st 2
    then
        printf "ascaapp warning!" 
    fi
}

function IDSYS_check
{
    printf "############################################################################################\n"
    printf "#                                        IDSYS                                             #\n"
    printf "############################################################################################\n"

    database_status
}

while getops ah:v current_opt
do
    case ${current_opt} in
        a)
        ;;
        h)
        ;;
        v)
        ;;
        *)
        ;;
    esac
done
