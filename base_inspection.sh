#!/bin/bash
#This is a base inspection script.

printf "############################################################################################\n"
printf "#                                            %s                                             \n", $(uname -n)
printf "############################################################################################\n"

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
        printf "%s WARNING: %s used over %d%.\n", current_host, $1, $5
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
free -m | awk -v current_host=$(uname -n) '
BEGIN{
    memery_health = 1
}
NR == 2{
    memery_total = $2
}
NR == 3{
    memery_used = $3 / memery_total * 100
    if (memery_used >= 90)
    {
        printf "%s WARNING: memery used over %.2f%%.\n", current_host, memery_used
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
#ping

#Check login record.
#reboot   system boot  2.6.18-128.el5   Wed May 12 07:57         (7+02:25)
last -s $(date -d "1 day ago" "+%Y-%m-%d")| awk -v current_host=$(uname -n) '
BEGIN{
    login_health = 1
}
/reboot/{
    printf "%s WARNING: rebooted at %s %s %s %s.\n", current_host, $5, $6, $7, $8
    login_health = 0
}
END{
    if (login_health == 1)
    {
        printf "%s login_record: OK.\n", current_host
    }
}'
