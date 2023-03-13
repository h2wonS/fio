#!/bin/bash

DEV=$1
DEVng=$2
filename=$3
BS=128k

if (($filename == "hynix"))
    then
    BS=192k
fi
 
TotalZone=2
mkdir result_${filename}

echo "EXPERIMENT 2-1-2 (reset all zones)  ############" 
sudo time ./run-zonereset-latency.sh $DEV                                             
echo "All zone state is now Empty(0x10)"                                           
sudo nvme zns report-zones $DEV -S 5                                       
echo "EXPERIMENT 1-2 (RandWrite) ############"
for ((base=0; base<=${TotalZone}; base++))
do
    for ((target=0; target<=${TotalZone}; target++))
    do
        sudo echo 3 > /proc/sys/vm/drop_caches
    if (( ${base} == ${target} ))
        then
        echo "" | tee -a  result_$filename/bw_${filename}_raw_write.dat
        continue
    fi

        diff=$((${target} - ${base}))
        echo "### ${base}Zone - ${target}Zone interference ###" | tee -a  result_$filename/bw_${filename}_write.dat
        sudo fio fio_${filename}.cfg --rw=write --offset=$((${base}*96))m --offset_increment=$((${diff}*96))m | tee  result_$filename/raw_${filename}_write.dat
        
        cat  result_$filename/raw_${filename}_write.dat | awk 'match($1, /bw/) {print $0}' | tee -a  result_$filename/bw_${filename}_write.dat
        cat  result_$filename/raw_${filename}_write.dat | awk 'match($2, /bw/) {print $0}' | tee -a  result_$filename/bw_${filename}_write.dat
        cat  result_$filename/raw_${filename}_write.dat | awk 'match($2, /bw/) {print $0}' | tee -a  result_$filename/bw_${filename}_raw_write.dat

        echo "### FULL STATE>>>>"
        sudo nvme zns report-zone ${DEV} -S 5
        sleep 10

        echo "### RESET ZONES>>>>"
        sudo nvme zns reset-zone ${DEV} -a
    done
    echo "                                    " | tee -a  result_$filename/bw_${filename}_raw_write.dat
done

