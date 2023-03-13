#!/bin/bash

DEV=$1
DEVng=$2
filename=$3
BS=128k

if (($filename == "hynix"))
    then
    BS=192k
fi
 
TotalZone=100
mkdir result_${filename}

echo "EXPERIMENT 1-1 (RandRead) ############"

for ((base=0; base<=15; base++))
do
    for ((target=16; target<=${TotalZone}; target++))
    do
        sudo echo 3 > /proc/sys/vm/drop_caches
        if (( ${base} == ${target} ))
            then
                echo "" | tee -a result_$filename/bw_${filename}_raw_randread.dat
                echo "" | tee -a l result_$filename/latency_${filename}_99p_raw_randread.dat
                continue
        fi

        diff=$((${target} - ${base}))

        if (( $diff < 0 ))
            then
                continue
        fi

        echo "### ${base}Zone - ${target}Zone interference ###" | tee -a  result_$filename/bw_${filename}_randread.dat
        sudo fio fio_${filename}.cfg --rw=randread --offset=$((${base}*96))m --offset_increment=$((${diff}*96))m | tee  result_$filename/raw_${filename}_randread.dat
        
        cat  result_$filename/raw_${filename}_randread.dat | awk 'match($1, /bw/) {print $0}' | tee -a  result_$filename/bw_${filename}_randread.dat
        cat  result_$filename/raw_${filename}_randread.dat | awk 'match($2, /bw/) {print $0}' | tee -a  result_$filename/bw_${filename}_randread.dat
        cat  result_$filename/raw_${filename}_randread.dat | awk 'match($2, /bw/) {print $0}' | tee -a  result_$filename/bw_${filename}_raw_randread.dat

        cat  result_$filename/raw_${filename}_randread.dat | awk 'match($2, /99/) {print $0}' | tee -a  result_$filename/latency_${filename}_99p_raw_randread.dat

    done
    echo "                                    " | tee -a  result_$filename/bw_${filename}_raw_randread.dat
    echo "                                    " | tee -a  result_$filename/latency_${filename}_99p_raw_randread.dat
done
cat  result_$filename/latency_${filename}_99p_raw_randread.dat | grep 99.00 | awk '{if(substr($3,4,1)!="]"){print substr($3,1,4)} else {print substr($3,1,3)}}' | tee result_$filename/latency_${filename}_99p_randread.dat

