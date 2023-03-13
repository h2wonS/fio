#!/bin/bash

$size=$1
$offset_increment=$2
$io_size=$3
sudo fio fio_we.cfg --offset_increment $offset_increment --io_size $io_size --size $size
