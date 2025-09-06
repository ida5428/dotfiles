#!/usr/bin/env bash

sprite_folder="$SCRIPTS_DIR/pokemon_sprites"
sprite_files=("$sprite_folder"/*)

count=${#sprite_files[@]}
random_index=$(( RANDOM % count ))

cat "${sprite_files[$random_index]}"

