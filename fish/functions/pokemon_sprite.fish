function pokemon_sprite
    # Set path to the sprite folder
    set sprite_folder $HOME/.config/zsh/sprites

    # Get all regular files in the folder (files only, no directories)
    set sprite_files (find $sprite_folder -type f)

    # Count how many files were found
    set count (count $sprite_files)

    # Choose a random index (Fish uses 1-based indexing)
    set random_index (random 1 $count)

    # Print an empty line and then the chosen sprite
    echo ""
    cat $sprite_files[$random_index]
end
