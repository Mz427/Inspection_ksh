#!/bin/bash

# eg: reanme_mz.sh -i "string1" -o "string2" -f files
#
set -e

parameter_input=""
parameter_output=""

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
if test ${#} -eq 0
then
    echo "No file selected!"
    exit 1
fi
for parameter_file in ${@}
do
    if ! test -e ${parameter_file}
    then
        echo "${parameter_file} is not exists"
        exit 1
    fi
    echo "${parameter_file} --> ${parameter_file/${parameter_input}/${parameter_output}}"
done
# Apply changes.
read -p "Apply above changes?(Y/n): " answer
if test ${answer} = "Y"
then
    for parameter_file in ${@}
    do
        mv -vi ${parameter_file} ${parameter_file/${parameter_input}/${parameter_output}}
    done
fi
