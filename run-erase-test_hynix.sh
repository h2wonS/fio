#!/bin/bash

#sudo dstat -D /dev/nvme0n1 | tee ./result_hynix_erase.dstat &
sudo fio fio_hynix_erase.cfg | tee ./result_hynix_output.log
