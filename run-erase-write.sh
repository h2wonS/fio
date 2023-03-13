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

totalzone=`sudo nvme zns report-zones $DEV | wc -l`
numlbas=24576
cmd=`sudo nvme zns report-zones $DEV -S 5 | wc -l`




if (($((cmd))==$totalzone))
    then 
    for ((idx=0; idx<128; idx++))
        do
            slba="0x"$(echo "obase=16; $numlbas*$idx" |bc)
            sudo nvme zns reset-zone $DEV -s $slba &
        done
#sudo time ./run-zonereset-latency_single.sh $slba $DEV 
fi

sudo fio fio_full_$filename.cfg                              
sudo nvme zns report-zones $DEV -S 1
exit



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
        sleep 3

        echo "### RESET ZONES>>>>"
        sudo nvme zns reset-zone ${DEV} -a
    done
    echo "                                    " | tee -a  result_$filename/bw_${filename}_raw_write.dat
done

