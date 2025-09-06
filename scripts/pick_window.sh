#!/usr/bin/env bash

selection=$( osascript -e '
   tell application "System Events"
      set output to ""
      set procs to (every process whose background only is false)
      repeat with p in procs
         set appName to name of p
         try
            repeat with w in (every window of p)
               set winName to name of w
               set output to output & appName & " -> " & winName & linefeed
            end repeat
         end try
      end repeat
   end tell
   return output
' | fzf)

if [[ -n "$selection" ]]; then
   app=$(echo $selection | awk -F ' -> ' '{print $1}')
   window=$(echo $selection | awk -F ' -> ' '{print $2}')

   osascript -e "
      tell application \"System Events\"
         tell application process \"$app\"
            repeat with w in windows
               if name of w is \"$window\" then
                  perform action \"AXRaise\" of w
                  exit repeat
               end if
            end repeat
         end tell
      end tell
      tell application \"$app\" to activate
   "
fi

