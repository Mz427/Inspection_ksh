#!/bin/ksh

function base_check
{
    #Check filesystem partiton.
    cat /proc/mounts | awk -v current_host=$(uname -n) '
    BEGIN{
        fs_health = 1
    }
    $4 ~ /^ro/{
        printf "%s WARNING: %s filesystem read only.\n", current_host, $2 
        fs_health = 0
    }
    END{
        if (fs_health == 1)
        {
            printf "%s filesystem: OK.\n", current_host
        }
    }'

    #Check disk space.
    df -h | sed '1d; s/%//' | awk -v current_host=$(uname -n) '
    BEGIN{
        disk_health = 1
    }
    {
        if ($5 >= 90)
        {
            printf "%s WARNING: %s has space over %d%.\n", current_host, $1, $5
            disk_health = 0
        }
    }
    END{
        if (disk_health == 1)
        {
            printf "%s disk_space: OK.\n", current_host
        }
    }'

    #Check memery space.
    free -m | awk -v current_host=$(uname -m) '
    BEGIN{
        memery_health = 1
    }
    NR==2{
        memery_total = $2
    }
    NR==3{
        memery_used = $3 / memery_total * 100 
        if (memery_used >= 90)
        {
            printf "%s WARNING: memery_space over %d%.\n", current_host, memery_used
            memery_health = 0
        }
    }
    END{
        if (memery_health == 1)
        {
            printf "%s memery_space: OK.\n", current_host
        }
    }'

    #Check network.
    ping 10.  awk

    #Check login record.
    #reboot   system boot  2.6.18-128.el5   Wed May 12 07:57         (7+02:25)
    last | grep 'reboot' | tee ${temp_file}
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
