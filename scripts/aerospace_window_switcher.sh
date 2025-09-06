#!/usr/bin/env bash

workspaces=()

for workspace in $(aerospace list-workspaces --all); do
   workspace_windows=$(aerospace list-windows --workspace $workspace | wc -l)
   [[ $workspace_windows -eq 0 ]] && continue

   for i in $(seq 1 $workspace_windows); do
      workspaces+=("$workspace | $(aerospace list-windows --workspace $workspace | head -n $i | tail -n 1)")
   done
done

printf '%s\n' "${workspaces[@]}" | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {3}")+abort'

