#!/bin/bash

#設定日誌陸徑.
source_dir="/home/gcagw/gci_home/log/"
destinatione_dir="/log_backup/"
string_today=$(date "+%Y%m%d%H%M")
#获取/分區容量.
root_capacity=$(df -h | sed -n '/\/$/s/%//p' | awk '{print $5}')
#获取/gci_home分區容量.
gci_home_capacity=$(df -h | sed -n '/gcagw/s/%//p' | awk '{print $5}')

#判断磁盤容量已满.
if test root_capacity -lt 85 -a gci_home_capacity -gt 90
then
    #轉移系統自動打包的tar.gz文件.
    for i in ${source_dir}*log.tar.gz
    do
        printf "mv:\n"
        mv -v ${i} ${destinatione_dir}
        #删除不需要的log文件.
        if test ${?} -eq 0
        then
            del_date=$(basename ${i})
            rm -v ${source_dir}${del_date:8}*log
        fi
    done
    #打包當天日誌文件.
    printf "rm:\n"
    for j in $(tar -czv -f ${destinatione_dir}${string_today}.log.tar.gz -C ${source_dir} ${string_today:8}??.log)
    do
        #删除當天不需要的log文件.
        if test ${?} -eq 0
        then
            rm -v ${source_dir}${j}
        fi
    done
fi
