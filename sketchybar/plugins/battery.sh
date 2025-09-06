#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

[[ "$PERCENTAGE" = "" ]] && exit 0

case ${PERCENTAGE} in
   [8-9][0-9] | 100)
      ICON=""
      ICON_COLOR=$GREEN
      ;;
   7[0-9])
      ICON=""
      ICON_COLOR=$GREEN
      ;;
   [4-6][0-9])
      ICON=""
      ICON_COLOR=$ORANGE
      ;;
   [2-3][0-9])
      ICON=""
      ICON_COLOR=$YELLOW
      ;;
   [0-1][0-9])
      ICON=""
      ICON_COLOR=$RED
      ;;
esac

[[ "$CHARGING" != "" ]] && ICON+="󱐋" && ICON_COLOR=$GREEN

sketchybar --set "$NAME" icon="${PERCENTAGE}%" label="$ICON" label.color=${ICON_COLOR}

