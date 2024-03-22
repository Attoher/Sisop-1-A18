#!/bin/bash

user=$(whoami)
time=$(date +"%Y%m%d")
timestamp=$(date +"%Y%m%d%H%M%S")
log_dir="/home/$user/metrics/$time"
mkdir -p "$log_dir"

ram_metrics=$(free -m | grep Mem)
ram_metrics=$(echo "$ram_metrics" | awk '{printf "%s,%s,%s,%s,%s,%s",$2,$3,$4,$5,$6,$7}')
swap_metrics=$(free -m | grep Swap)
swap_metrics=$(echo "$swap_metrics" | awk '{printf "%s,%s,%s",$2,$3,$4}')

target_path="/home/$user/"
dir_size=$(du -sh $target_path | awk '{print $1}')
log_file="$log_dir/metrics_$timestamp.log"
echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "$log_file"
echo "$ram_metrics,$swap_metrics,/home/$user/,$dir_size" >> "$log_file"

chmod 600 "$log_dir"/*.log
