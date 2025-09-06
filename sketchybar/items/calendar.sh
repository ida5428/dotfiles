#!/usr/bin/env bash

calendar=(
   padding_left=2
   padding_right=2
   icon.padding_left=10
   icon.padding_right=10
   label.padding_right=10
   background.color=$BACKGROUND_1
   background.border_color=$BACKGROUND_2
   update_freq=30
   script="$PLUGIN_DIR/calendar.sh"
)

sketchybar --add item calendar right \
           --set calendar "${calendar[@]}" \
           --subscribe calendar system_woke

