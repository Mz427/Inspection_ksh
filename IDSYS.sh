#!/bin/bash

current_host=$(uname -n)
sybase_log=/opt/sybase-12.5/ASE-12_5/install/idsys.log
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

/opt/sybase-12.5/OCS-12_5/bin/isql -U sa -P sZ13Sjk7 -S idsys -w 1000 << EOF | \
awk -v db_name="IDSYSOIL" -v current_host=${current_host} '
BEGIN {
    oil_size = 0
    oil_free = 0
    log_size = 0
    log_free = 0
}
$1 ~ /IDSYSOIL/ {
    oil_size = $2
}
$1 ~ /IDSYS_dev/ {
    oil_free += $NF
}
$1 ~ /IDSYS_log/ {
    log_size += $2
}
/log only free kbytes/ {
    log_free = $NF
}
END {
    oil_free /= 1024
    log_free /= 1024
    if (oil_free / oil_size < 0.3 && log_free / log_size < 0.3)
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
