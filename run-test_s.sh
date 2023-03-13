#!/bin/bash

i=1
for i in {1..10}
do
    mkdir ./SamsungResult0$i
    sudo ./run-fio-bw_s.sh /dev/nvme1n1 /dev/ng1n1 samsung $1 | tee total_samsung_test_$i.log
    mv result_samsung total_samsung_test_$i.log SamsungResult0$i/
done
