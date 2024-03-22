#!/bin/bash

user=$(whoami)
time=$(date +"%Y%m%d")
timestamp=$(date +"%Y%m%d%H")
log_dir="/home/$user/metrics/$time"
output_file="$log_dir/metrics_agg_$timestamp.log"

echo "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > $output_file

awk -F, '
NR>1 {
    for (i=1; i<=NF; i++) {
        if (NR==2) {
            min[i] = $i
            max[i] = $i
            sum[i] = $i
        } 
        else if (NR%2==0) {
            if ($i+0 < min[i]+0) min[i] = $i
            if ($i+0 > max[i]+0) max[i] = $i
            sum[i] += $i
        }
    }
    records++
}
END {
    printf "minimum,"
for (i=1; i<=NF; i++) printf "%s%s", (i == 1 || i == NF ? "" : ","), min[i]
printf "\n"

printf "maximum,"
for (i=1; i<=NF; i++) printf "%s%s", (i == 1 || i == NF ? "" : ","), max[i]
printf "\n"

printf "average,"
for (i=1; i<NF; i++) {
    if (i == 10)
        printf "%s%s", ",/home/ubuntu/,", ""
    else if (i==11)
        printf "%s%s", (i == 1 || i == NF-1 ? "" : ","), sum[i]*2/records
    else if (i<=11)
        printf "%s%s", (i == 1 || i == NF-1 ? "" : ","), sum[i]*2/records
}
printf "G\n"

}' $log_dir/metrics_*.log >> $output_file
