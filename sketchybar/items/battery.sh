#!/usr/bin/env bash

battery=(
   padding_left=2
   padding_right=2
   icon.padding_left=10
   icon.padding_right=10
   label.padding_right=10
   label.font="$FONT:Regular:20.0"
   background.color=$BACKGROUND_1
   background.border_color=$BACKGROUND_2
   update_freq=120
   script="$PLUGIN_DIR/battery.sh"
)

sketchybar --add item battery right \
           --set battery "${battery[@]}" \
           --subscribe battery power_source_change system_woke

