#!/bin/bash

sudo nvme zns reset-zone /dev/nvme1n1 -a
dstat -D /dev/nvme1n1 | tee ./100p_result_samsung_erase.dstat &
sudo fio fio_samsung_erase.cfg | tee ./100p_result_samsung_output.log
