#!/bin/bash

StartTime=$(date +%s.%N)

sudo nvme zns reset-zone $1 -a

EndTime=$(date +%s.%N)

ElapsedTime=`echo "$EndTime-$StartTime" | bc`
stime=`echo "$ElapsedTime-(($ElapsedTime/60)*60)" | bc`

#echo "It takes $(($EndTime - $StartTime)) seconds to complete this task."
echo "TotalTime= $stime (sec)"
