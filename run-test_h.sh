#!/bin/bash

for i in {1..10}
do
    mkdir ./newHynixResult0$i
    sudo ./run-fio-bw_h.sh /dev/nvme0n1 /dev/ng0n1 hynix $1 | tee total_read_hynix_test_$i.log
    mv result_hynix total_read_hynix_test_$i.log newHynixResult0$i/
done
