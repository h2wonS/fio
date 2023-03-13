#!/bin/bash

echo 1 > /sys/kernel/debug/tracing/events/nvme/nvme_setup_cmd/enable

cat /sys/kernel/debug/tracing/trace_pipe | tee trace_pipe.log
