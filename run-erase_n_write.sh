#!/bin/bash

DEV=$1
filename=$2
cap=$(($3 / 100))
BS=128k
numlbas=24576
fullsize=$((30528 * 1024 * 1024))
totTime=2700

if (($filename == "hynix"))
    then
    BS=192k
fi
 
mkdir result_${filename}

#sudo nvme zns reset-zone $DEV -a

totalzone=`sudo nvme zns report-zones $DEV | wc -l`
cmd=`sudo nvme zns report-zones $DEV -S 5 | wc -l`


echo DEV=$DEV filename=$filename cap=$cap BS=$BS fullsize=$fullsize 
echo runtime=$(($totTime / $cap)) --size=$(($fullsize / $cap)) --offset=0 --offset_increment=$(($fullsize / $cap))
echo $cmd
echo $((${totalzone}*${cap}))
echo runtime=$((${totTime} / $((1 - ${cap})))) --size=$((${fullsize} / $((1 - ${cap})))) --offset=$(($(($totalzone - 1)) * $((1 - ${cap}))))z --offset_increment=$((${fullsize} / $((1 - ${cap}))))
echo $(date +%H%M%s.%N)

exit


sudo fio fio_samsung_cap.cfg --runtime=$(($totTime / $cap)) --size=$(($fullsize / $cap)) --offset=0 --offset_increment=$(($fullsize / $cap)) & 

for (;;;)
    do
        if (($((cmd))==$((${totalzone}*${cap}))))
            then 
            echo 
            break
        fi
    done

sudo fio fio_samsung_fcap.cfg --runtime=$((${totTime} / $((1 - ${cap})))) --size=$((${fullsize} / $((1 - ${cap})))) --offset=$(($(($totalzone - 1)) * $((1 - ${cap}))))z --offset_increment=$((${fullsize} / $((1 - ${cap})))) & 

for (;;;)
    do
        if (($((cmd))==$totalzone))
            then 
            echo
            break
        fi
    done

