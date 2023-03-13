#!/bin/bash

DEV=$1
DEVng=$2
filename=$3
BS=128k
t=$4

if (($filename == "hynix"))
    then
    BS=192k
fi
 
TotalZone=100

echo "EXPERIMENT 1-1 (RandRead) ############"

for ((base=0; base<=${TotalZone}; base++))
do
    for ((target=0; target<=${TotalZone}; target++))
    do
        sudo echo 3 > /proc/sys/vm/drop_caches
        if (( ${base} == ${target} ))
            then
                echo "" | tee -a bw_${filename}_raw_randread.dat
                echo "" | tee -a latency_${filename}_99p_randread.dat
                continue
        fi

        diff=$((${target} - ${base}))
        echo "### ${base}Zone - ${target}Zone interference ###" | tee -a bw_${filename}_randread.dat
        sudo fio fio_${filename}.cfg --rw=randread --offset=$((${base}*96))m --offset_increment=$((${diff}*96))m | tee raw_${filename}_randread.dat
        
        cat raw_${filename}_randread.dat | awk 'match($1, /bw/) {print $0}' | tee -a bw_${filename}_randread.dat
        cat raw_${filename}_randread.dat | awk 'match($2, /bw/) {print $0}' | tee -a bw_${filename}_randread.dat
        cat raw_${filename}_randread.dat | awk 'match($2, /bw/) {print $0}' | tee -a bw_${filename}_raw_randread.dat

        cat raw_${filename}_randread.dat | awk 'match($2, /99/) {print $0}' | tee -a latency_${filename}_99p_raw_randread.dat
        cat raw_${filename}_randread.dat | awk 'match($2, /99/) {print $0}' | awk 'NR==1{print substr($3,1,3)}' | tee -a latency_${filename}_99p_randread.dat

    done
    echo "                                    " | tee -a bw_${filename}_raw_randread.dat
    echo "                                    " | tee -a latency_${filename}_99p_randread.dat
    echo "                                    " | tee -a latency_${filename}_99p_raw_randread.dat
done

mkdir result_${filename}_$t
mv *.dat ./result_${filename}_$t/

exit

echo "EXPERIMENT 1-2 (SeqRead) ############"

for ((base=0; base<=${TotalZone}; base++))
do
    for ((target=0; target<=${TotalZone}; target++))
    do
        sudo echo 3 > /proc/sys/vm/drop_caches
        if (( ${base} == ${target} ))
            then
                echo "" | tee -a bw_${filename}_raw_seqread.dat
                echo "" | tee -a latency_${filename}_99p_seqread.dat
                continue
        fi

        diff=$((${target} - ${base}))
        echo "### ${base}Zone - ${target}Zone interference ###" | tee -a bw_${filename}_seqread.dat
        sudo fio fio_${filename}.cfg --rw=read --offset=$((${base}*96))m --offset_increment=$((${diff}*96))m | tee raw_${filename}_seqread.dat
        
        cat raw_${filename}_seqread.dat | awk 'match($1, /bw/) {print $0}' | tee -a bw_${filename}_seqread.dat
        cat raw_${filename}_seqread.dat | awk 'match($2, /bw/) {print $0}' | tee -a bw_${filename}_seqread.dat
        cat raw_${filename}_seqread.dat | awk 'match($2, /bw/) {print $0}' | tee -a bw_${filename}_raw_seqread.dat

        cat raw_${filename}_randread.dat | awk 'match($2, /99/) {print $0}' | tee -a latency_${filename}_99p_raw_seqread.dat
        cat raw_${filename}_seqread.dat | awk 'match($2, /99/) {print $0}' | awk 'NR==1{print substr($3,1,3)}' | tee -a latency_${filename}_99p_seqread.dat

    done
    echo "                                    " | tee -a bw_${filename}_raw_seqread.dat
    echo "                                    " | tee -a latency_${filename}_99p_seqread.dat
    echo "                                    " | tee -a latency_${filename}_99p_raw_seqread.dat
done

mkdir result_${filename}+
mv *.dat ./result_${filename}+/


