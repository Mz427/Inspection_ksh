#!/bin/bash
#This is a base inspection script.

printf "############################################################################################\n"
printf "#                                            %s                                             \n" $(uname -n)
printf "############################################################################################\n"

#Check filesystem partiton.
#/dev/root / ext3 rw,data=ordered 0 0
cat /proc/mounts | awk -v current_host=$(uname -n) '
BEGIN {
    fs_health = 1
}
$4 ~ /^ro/ {
    printf "%s WARNING: %s filesystem read only.\n", current_host, $2
    fs_health = 0
}
END {
    if (fs_health == 1)
    {
        printf "%s filesystem: OK.\n", current_host
    }
}'

#Check disk space.
#Filesystem            Size  Used Avail Use% Mounted on
#/dev/hda3              99G  7.4G   87G   8% /
df -h | sed '1d; s/%//' | awk -v current_host=$(uname -n) '
BEGIN {
    disk_health = 1
}
{
    if ($5 >= 90)
    {
        printf "%s WARNING: %s used over %d%.\n", current_host, $1, $5
        disk_health = 0
    }
}
END {
    if (disk_health == 1)
    {
        printf "%s disk_space: OK.\n", current_host
    }
}'

#Check memery space.
#             total       used       free     shared    buffers     cached
#Mem:         64466       6162      58303          0        352       5554
#-/+ buffers/cache:        255      64210
#Swap:        32765          0      32765
free -m | awk -v current_host=$(uname -n) '
BEGIN {
    memery_health = 1
}
NR == 2 {
    memery_total = $2
}
NR == 3 {
    memery_used = $3 / memery_total * 100
    if (memery_used >= 90)
    {
        printf "%s WARNING: memery used over %.2f%%.\n", current_host, memery_used
        memery_health = 0
    }
}
END {
    if (memery_health == 1)
    {
        printf "%s memery_space: OK.\n", current_host
    }
}'

#Check network.
#PING 10.0.0.1 (10.10.0.1) 56(84) bytes of data.
#64 bytes from 10.199.200.139: icmp_seq=1 ttl=64 time=1.48 ms
#64 bytes from 10.199.200.139: icmp_seq=2 ttl=64 time=0.161 ms
#64 bytes from 10.199.200.139: icmp_seq=3 ttl=64 time=0.245 ms
#
#--- 10.199.200.139 ping statistics ---
#3 packets transmitted, 3 received, 0% packet loss, time 1999ms
#rtt min/avg/max/mdev = 0.161/0.629/1.482/0.604 ms

#Check time synchronization.

#Check login record.
#reboot   system boot  2.6.18-128.el5   Wed May 12 07:57         (7+02:25)
last -s $(date -d "1 day ago" "+%Y-%m-%d")| awk -v current_host=$(uname -n) '
BEGIN {
    login_health = 1
}
/reboot/ {
    printf "%s WARNING: rebooted at %s %s %s %s.\n", current_host, $5, $6, $7, $8
    login_health = 0
}
END {
    if (login_health == 1)
    {
        printf "%s login_record: OK.\n", current_host
    }
}'
