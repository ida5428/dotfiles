if test "$TERM_PROGRAM" = ghostty
    pokemon_sprite
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_user_key_bindings
    bind \r __handle_enter
end

function __handle_enter
    set -l line (commandline)

    # Trim the line of whitespace
    set -l trimmed (string trim "$line")

    if test -z "$trimmed"
        # Empty or whitespace-only: clear line and redraw fresh prompt
        commandline --replace '' # Clear current input
        commandline -f repaint # Redraw prompt
    else
        # Otherwise, execute normally
        commandline -f execute
    end
end

# Remove greeting message
set fish_greeting ""
set -g fish_color_autosuggestion b0b0b0

# Source starship
starship init fish | source

# Add Homebrew to path
eval "$(/opt/homebrew/bin/brew shellenv)"

# Aliases
alias dev="cd Developer && ls -1"

set -Ux EDITOR nvim
set -Ux VISUAL nvim
