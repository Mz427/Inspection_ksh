#!/bin/bash

current_host=$(uname -n)
date_database_log=/opt/sybase-12.5/ASE-12_5/install/asca.log
date_today=$(date +"%Y%m%d")
date_yesterday=$(date -d "1 day ago" +"%Y%m%d")
date_database_log=$(ls -l --time-style '+%Y%m%d' ${sybase_log} | cut -d ' ' -f 6)

if test "${date_database_log}" = "${date_today}" -o "${date_database_log}" = "${date_yesterday}"
then
    printf "%s WARNNING: sybase service has new log.\n"
else
    printf "%s sybase log: ok.\n"
fi

/opt/sybase-12.5/OCS-12_5/bin/isql -U sa -P sZ14Sjk6 -S asca -w 1000 | \
awk -v current_host=${current_host} '
BEGIN
{

}
/ASCAOIL/
{
    printf
}' << EOF
sp_helpdb ASCAOIL
go
sp_helpdb master
go
exit
EOF
