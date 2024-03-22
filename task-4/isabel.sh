#!/bin/bash

hour=$(date +"%H")
hour_elapsed=0
count_image=0
count_folder=0
count_zip=0

read -r hour hour_elapsed count_image count_folder count_zip< save.txt
((hour++))
((hour_elapsed++))

if [ "$hour" == "24" ]; then
    hour=0
fi


if [ "$hour" == "0" ] && [ "$((hour_elapsed / 24))" -gt "0" ]; then
    download_count=10
    folder_counter=$((count_folder + 1))
    folder_name="folder_${folder_counter}"
    mkdir "${folder_name}"
elif [ "$((hour % 2))" == "0" ] && [ "$((hour_elapsed % 5))" == "0" ] && [ "$((hour_elapsed / 5))" -gt "0" ]; then
    download_count=5
    folder_counter=$((count_folder + 1))
    folder_name="folder_${folder_counter}"
    mkdir "${folder_name}"
elif [ "$((hour % 2))" == "1" ] && [ "$((hour_elapsed % 5))" == "0" ] && [ "$((hour_elapsed / 5))" -gt "0" ]; then
    download_count=3
    folder_counter=$((count_folder + 1))
    folder_name="folder_${folder_counter}"
    mkdir "${folder_name}"
fi

for ((i = 1; i <= download_count; i++)); do
    count_image=$((count_image + 1))
    wget -q "https://cdns.klimg.com/mav-prod-resized/480x/ori/feedImage/2023/6/20/1687240572210-t0s77.jpeg" -O "${folder_name}/foto_${count_image}.jpg"
done

if [ "$((hour_elapsed % 10))" == "0" ] && [ "$hour_elapsed" -gt "9" ]; then
    zip_counter=$((count_zip + 1))
    zip_name="ayang_${zip_counter}.zip"
    zip -r "${zip_name}" "${folder_name}"
    ((count_zip++))
    ((count_folder++))
fi


if [ "$hour" == "2" ]; then
    find . -type d -name "folder_*" -exec rm -rf {} +
    find . -type f -name "*.zip" -delete

    count_image=0
    count_folder=0
    count_zip=0
fi


current_date=$(date +"%Y%m%d")

if [ "$(((hour_elapsed/24) % 2))" == "0" ]; then
    wget -q "https://i.pinimg.com/474x/c1/25/b4/c125b418273f54f3ceb9922f86906f0a.jpg" -O "levi_${current_date}.jpg"
elif [ "$(((hour_elapsed/24) % 2))" == "1" ]; then
    wget -q "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgJnBohVarNHe70tGqdyCQZA2035BLHW0mr5yfhrLWNJ3uZy418_iN1yNTZljI7VssYzk&usqp=CAU" -O "eren_${current_date}.jpg"
fi


echo "$hour $hour_elapsed $count_image $count_folder $count_zip" > save.txt
