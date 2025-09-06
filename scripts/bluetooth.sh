#!/usr/bin/env bash

clear

# Bluetooth off, only option is turn on
if [[ $(blueutil --power) -eq 0 ]]; then
   selected=$(echo -e "\033[34mTurn Bluetooth On\033[0m" | fzf --ansi)
   [[ -z "$selected" ]] && exit 0
   blueutil --power 1
   sleep 0.5
fi

# Bluetooth on, show devices and turn off bluetooth"
menu=$(
   echo -e "\033[34mTurn Bluetooth Off\033[0m"
   blueutil --paired | awk -F', ' '{
      for(i=1;i<=NF;i++){
         if($i ~ /^name:/){gsub(/^name: "|\"$/, "", $i); name=$i}
         if($i ~ /connected/){status="connected"}
         if($i ~ /not connected/){status="disconnected"}
      }
      color=(status=="connected") ? "\033[32m" : "\033[31m"
      print color name " [" status "]\033[0m"
   }'
)

# Select device
selected=$(echo "$menu" | fzf --ansi)
[[ -z "$selected" ]] && exit 0

if [[ "$selected" == *"Turn Bluetooth Off"* ]]; then
   blueutil --power 0 && echo "Bluetooth turned off."
   exit 0
fi

device_name=$(echo "$selected" | sed 's/ \[.*\]//')
device_addr=$(blueutil --paired | grep -F "name: \"$device_name\"" | awk -F', ' '{print $1}' | awk -F': ' '{print $2}')

if [[ "$selected" == *"[connected]"* ]]; then
   blueutil --disconnect "$device_addr"
else
   blueutil --connect "$device_addr"
fi

