function pokemon_sprite
    # Set the path to your sprite folder
    set sprite_folder ~/.config/fish/functions/pokemon_sprites

    # Get a list of all files in the sprite folder (no extension check)
    set sprite_files (find $sprite_folder -type f)

    # Generate a random index (between 1 and the number of files)
    set random_index (math (random) % (count $sprite_files))

    # Ensure that random_index is never 0, since Fish uses 1-based indexing
    if test $random_index -eq 0
        set random_index 1
    end

    # Get the file at the random index
    set random_sprite $sprite_files[$random_index]

    # Print the contents of the random sprite file
    echo ''
    cat $random_sprite
end
