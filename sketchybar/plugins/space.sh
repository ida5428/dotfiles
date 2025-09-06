#!/usr/bin/env bash

if [ "$SENDER" = "space_change" ]; then
   source "$CONFIG_DIR/colors.sh"
   COLOR=$BACKGROUND_2

   [[ "$SELECTED" = "true" ]] && COLOR=$GREY
   
   sketchybar --set space.$(aerospace list-workspaces --focused) \
                    icon.highlight=true \
                    label.highlight=true \
                    background.border_color=$COLOR
fi
