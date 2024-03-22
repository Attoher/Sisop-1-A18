#!/bin/bash

user=$(whoami)
time=$(date +"%Y%m%d")
timestamp=$(date +"%Y%m%d%H")
log_dir="/home/$user/metrics/$time"
backup_dir="/home/$user/metrics/backup"
mkdir -p "$backup_dir"

backup_file="$backup_dir/backup_metrics_$timestamp.gz"

cat "$log_dir"/metrics_agg_*.log | gzip > "$backup_file"
