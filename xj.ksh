#!/bin/ksh

function disk_space_count
{
}

function memery_space_count
{
}

function if_reboot
{
}

function network_status
{
}

function database_status
{
}

function ascaapp_check
{
    printf "############################################################################################"
    printf "#                                     ascaapp                                              #"
    printf "############################################################################################"
    
    ssh asca@
    temp_file='/tmp/$(mktemp)'
    df -h | tee ${temp_file}
    free -m | tee ${temp_file}
    ping 10.
    last | grep 'reboot' | tee ${temp_file}
    #reboot   system boot  2.6.18-128.el5   Wed May 12 07:57         (7+02:25)
    ps -ef | grep java | tee ${temp_file}
}

function ASCA_check
{
    printf "############################################################################################"
    printf "#                                        ASCA                                              #"
    printf "############################################################################################"
}

function idsysapp_check
{
    printf "############################################################################################"
    printf "#                                        idsysapp                                          #"
    printf "############################################################################################"
}

function IDSYS_check
{
    printf "############################################################################################"
    printf "#                                        IDSYS                                             #"
    printf "############################################################################################"
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
