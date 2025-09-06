#!/usr/bin/env bash

COMMANDS=(
   " " # empty slot

   # apps
   "app/zen                -> open -a 'Zen'"
   "app/ghostty            -> open -a 'Ghostty'"
   "app/spotify            -> open -a 'Spotify'"

   # system apps
   "app/sys/finder         -> open -a 'Finder'"
   "app/sys/safari         -> open -a 'Safari'"
   "app/sys/settings       -> open -a 'System Settings'"

   # system functions
   "sys/lock               -> shortcuts run 'Lock'"
   "sys/sleep              -> shortcuts run 'Sleep'"
   "sys/shutdown           -> shortcuts run 'Shut Down'"

   # terminal
   "term/fish              -> fish"
   "term/nvim              -> nvim"
   "term/yazi              -> env NEOVIM_YAZI=1 yazi"

   # utils
   "utils/bluetooth        -> $SCRIPTS_DIR/bluetooth.sh"
   "utils/sound-output     -> $SCRIPTS_DIR/sound_output.sh"
   "utils/window-switch    -> $SCRIPTS_DIR/aerospace_window_switcher.sh"

   # rayterm
   "rayterm/edit           -> nvim $SCRIPTS_DIR/rayterm.sh"
   "rayterm/reset          -> exec $SCRIPTS_DIR/rayterm.sh"
)

while true; do
   clear
   selected=$(printf '%s\n' "${COMMANDS[@]}" | fzf --bind='esc:clear-query+pos(1)')
   [[ -z $selected ]] && break
   eval "$(echo $selected | awk -F '->' '{print $2}')"
done

