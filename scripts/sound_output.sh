#!/usr/bin/env bash

current=$(SwitchAudioSource -c -t output)

menu=$(
   SwitchAudioSource -a -t output | while read -r device; do
      if [[ "$device" == "$current" ]]; then
         echo -e "\033[32m$device [current]\033[0m"
      else
         echo -e "\033[31m$device\033[0m"
      fi
   done
)

selected=$(echo "$menu" | fzf --ansi)
[[ -z "$selected" ]] && exit 0

device=$(echo "$selected" | sed -E 's/\x1B\[[0-9;]*[JKmsu]//g' | sed 's/ \[current\]//')
SwitchAudioSource -s "$device"

