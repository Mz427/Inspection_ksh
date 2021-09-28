#!/bin/bash

#检查服务进程.
current_host=$(uname -n)

function check_process
{
    if test -n "$(ps -ef | grep "${1}" | grep -v "grep")"
    then
        printf "%s precess %s: OK.\n" ${current_host} ${1}
    else
        printf "%s WARNING: no %s process.\n" ${current_host} ${1}
    fi
}

check_process server_all
check_process server_web
check_process gcapp_main

#設定日誌路徑.
source_dir="/home/gcagw/gci_home/log/"
destination_dir="/log_backup/"
xml_tmp_dir=${destination_dir}"tmp_xml/"
string_today=$(date "+%Y%m%d%H%M")
#获取/分區容量.
root_capacity=$(df -h | sed -n '/\/$/s/%//p' | awk '{print $5}')
#获取/gci_home分區容量.
gci_home_capacity=$(df -h | sed -n '/gcagw/s/%//p' | awk '{print $5}')
#如未获取得值,設為默認值.
printf "root_capacity: %d.\n" ${root_capacity:=100}
printf "gci_home_capacity: %d.\n" ${gci_home_capacity:=0}

#判断磁盤容量是否已满.
if test $(printf "${root_capacity} < 85\n" | bc) -eq 1 -a $(printf "${gci_home_capacity} > 90\n" | bc) -eq 1
then
    #轉移系統自動打包的tar.gz文件.
    tar_old=$(ls ${source_dir} | grep 'log\.tar\.gz$')
    if test -n "${tar_old}"
    then
        for i in ${tar_old}
        do
            mv -v ${source_dir}${i} ${destination_dir}
            #删除不需要的log文件.
            if test ${?} -eq 0
            then
                rm -v ${source_dir}${i:0:8}*log
            fi
        done
    fi

    #打包當天日誌文件,深圳无需執行.
    province_code=$(uname -n)
    if test "${province_code:5:2}" = "44"
    then
        files_today=$(ls ${source_dir} | grep -E "^${string_today:0:8}[[:digit:]]{2}.log")
        if test -n "${files_today}"
        then
            for j in $(tar -czv -f ${destination_dir}${string_today}.log.tar.gz -C ${source_dir} ${files_today})
            do
                #删除當天不需要的log文件.
                if test ${?} -eq 0
                then
                    rm -v ${source_dir}${j}
                fi
            done
        fi
    fi

    #處理XML日誌.
    #创建临時轉儲目錄.
    if test ! -d ${xml_tmp_dir}
    then
        mkdir ${xml_tmp_dir}
    fi
    if test -d ${xml_tmp_dir}
    then
        #轉移旧XML日誌.
        for i in $(ls ${source_dir} | grep '^XML.*log')
        do
            if test "${i:4:8}" != "${string_today:0:8}"
            then
                mv -vi ${source_dir}${i} ${xml_tmp_dir}
            fi
        done
        #每月初打包上月XML日誌.
        if test ${string_today:6:2} = "01"
        then
            last_month=$(date -d "1 month ago" "+%Y%m")
            files_last_month=$(ls ${xml_tmp_dir} | grep -E "^XML_${last_month}[[:digit:]]{4}.log")
            if test -n "${files_last_month}"
            then
                for j in $(tar -czv -f ${destination_dir}XML_${last_month}.log.tar.gz -C ${xml_tmp_dir} ${files_last_month})
                do
                    #删除上月已打包XML日誌.
                    if test ${?} -eq 0
                    then
                        rm -v ${xml_tmp_dir}${j}
                    fi
                done
            fi
        fi
    fi
fi
