#!/usr/bin/env bash

case "$1" in
   "Zen")     echo ":zen_browser:" ;;
   "Arc")     echo ":arc:" ;;
   "Ghostty") echo ":ghostty:" ;;
   "Spotify") echo ":spotify:" ;;
   *)         echo ":default:" ;;
esac
