#!/bin/bash

current_host=$(uname -n)
sybase_log=/opt/sybase-12.5/ASE-12_5/install/asca.log
date_today=$(date +"%Y%m%d")
date_yesterday=$(date -d "1 day ago" +"%Y%m%d")
date_database_log=$(ls -l --time-style '+%Y%m%d' ${sybase_log} | awk '{print $6}')

if test $(/opt/sybase-12.5/ASE-12_5/install/showserver | wc -l) -ne 5
then
    printf "%s WARNNING: sybase lose service.\n"
    exit 1
fi
if test "${date_database_log}" = "${date_today}" -o "${date_database_log}" = "${date_yesterday}"
then
    printf "%s WARNNING: sybase service has new log.\n"
else
    printf "%s sybase log: ok.\n"
fi

/opt/sybase-12.5/OCS-12_5/bin/isql -U sa -P sZ14Sjk6 -S asca -w 1000 << EOF | \
awk -v db_name="ASCAOIL" -v current_host=${current_host} '
BEGIN {
    ascaoil_size = 0
    ascaoil_free = 0
    ascalog_size = 0
    ascalog_free = 0
}
$1 ~ /ASCAOIL/ {
    ascaoil_size = $2
}
$1 ~ /ASCA_dev/ {
    ascaoil_free += $NF
}
$1 ~ /ASCA_log/ {
    ascalog_size += $2
}
/log only free kbytes/ {
    ascalog_free = $NF
}
END {
    ascaoil_free /= 1024
    ascalog_free /= 1024
    if (ascaoil_free / ascaoil_size < 0.3 && ascalog_free / ascalog_size < 0.3)
        printf "%s WARNNING: %s has not enough space.\n", current_host, db_name
    else
        printf "%s sybase: %s OK.\n", current_host, db_name
}'
use ASCAOIL
go
sp_helpdb ASCAOIL
go
exit
EOF
