#!/bin/bash

#設定日誌陸徑.
source_dir="/home/gcagw/gci_home/log/"
destination_dir="/log_backup/"
string_today=$(date "+%Y%m%d%H%M")
#获取/分區容量.
root_capacity=$(df -h | sed -n '/\/$/s/%//p' | awk '{print $5}')
#获取/gci_home分區容量.
gci_home_capacity=$(df -h | sed -n '/gcagw/s/%//p' | awk '{print $5}')
#如未获取得值,設為默認值.
printf "root_capacity: %d.\n" ${root_capacity:=100}
printf "gci_home_capacity: %d.\n" ${gci_home_capacity:=0}

#判断磁盤容量已满.
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
        file_today=$(ls ${source_dir} | grep -E "${string_today:0:8}[[:digit:]]{2}.log")
        if test -n "${file_today}"
        then
            for j in $(tar -czv -f ${destination_dir}${string_today}.log.tar.gz -C ${source_dir} ${file_today})
            do
                #删除當天不需要的log文件.
                if test ${?} -eq 0
                then
                    rm -v ${source_dir}${j}
                fi
            done
        fi
    fi
fi
