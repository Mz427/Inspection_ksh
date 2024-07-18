#!/bin/bash

# eg: reanme_mz.sh -i "string1" -o "string2" -f files
#
set -e

parameter_input=""
parameter_output=""
i=0
j=1
files_before=()
files_after=()

while getopts "i:o:f:" current_opt
do
    case ${current_opt} in
        i)
            parameter_input=${OPTARG}
            ;;
        o)
            parameter_output=${OPTARG}
            ;;
        *)
            echo "Wrong parameter!"
            exit 1
            ;;
    esac
done
if test -z ${parameter_input}
then
    echo "Wrong parameter!"
    exit 1
fi
# List changes.
shift $(echo "${OPTIND} - 1" | bc)
amount_of_files=${#}
while test ${i} -lt ${amount_of_files}
do
    files_before[${i}]=${1}
    files_after[${i}]=${files_before[${i}]/${parameter_input}/${parameter_output}}
    echo "${files_before[${i}]} --> ${files_after[${i}]}"
    i=$(echo "${i} + 1" | bc)
    j=$(echo "${j} + 1" | bc)
    shift
done
# Apply changes.
read -p "Apply above changes?(Y/n): " answer
i=0
if test ${answer} = "Y"
then
    while test ${i} -lt ${#files_before[@]}
    do
        mv -vi ${files_before[${i}]} ${files_after[${i}]}
        i=$(echo "${i} + 1" | bc)
    done
fi
