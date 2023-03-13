#!/bin/bash
echo "#############################"
sudo nvme zns reset-zone /dev/nvme1n1 -a
dstat -D /dev/nvme1n1 > 0207_95p2.dstat &
sudo fio fio_we_95p.cfg | tee 0207_95p2.out
sudo pkill -9 dstat
sudo nvme zns report-zones /dev/nvme1n1 -S 5 | wc -l

exit

echo "#############################"
sudo nvme zns reset-zone /dev/nvme1n1 -a
dstat -D /dev/nvme1n1 > 0207_70p.dstat &
sudo fio fio_we_70p.cfg | tee 0207_70p.out
sudo pkill -9 dstat
sudo nvme zns report-zones /dev/nvme1n1 -S 5 | wc -l

echo "#############################"
sudo nvme zns reset-zone /dev/nvme1n1 -a
dstat -D /dev/nvme1n1 > 0207_80p.dstat &
sudo fio fio_we_80p.cfg | tee 0207_80p.out
sudo pkill -9 dstat
sudo nvme zns report-zones /dev/nvme1n1 -S 5 | wc -l

echo "#############################"
sudo nvme zns reset-zone /dev/nvme1n1 -a
dstat -D /dev/nvme1n1 > 0207_90p.dstat &
sudo fio fio_we_90p.cfg | tee 0207_90p.out
sudo pkill -9 dstat
sudo nvme zns report-zones /dev/nvme1n1 -S 5 | wc -l

echo "#############################"
sudo nvme zns reset-zone /dev/nvme1n1 -a
dstat -D /dev/nvme1n1 > 0207_95p.dstat &
sudo fio fio_we_95p.cfg | tee 0207_95p.out
sudo pkill -9 dstat
sudo nvme zns report-zones /dev/nvme1n1 -S 5 | wc -l
echo "#############################"
sudo nvme zns reset-zone /dev/nvme1n1 -a
dstat -D /dev/nvme1n1 > 0207_100p.dstat &
sudo fio fio_we_100p.cfg | tee  0207_100p.out
sudo pkill -9 dstat
sudo nvme zns report-zones /dev/nvme1n1 -S 5 | wc -l
