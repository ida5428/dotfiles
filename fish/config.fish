if status is-interactive
   if contains -- "$TERM_PROGRAM" "tmux" "ghostty"
      $SCRIPTS_DIR/pokemon_sprite.sh
   end

   function fish_user_key_bindings
      bind \r __handle_enter
   end

   function __handle_enter
      set -l line (commandline)
      set -l trimmed (string trim -- "$line")

      if test -z "$trimmed"
         commandline -f repaint
         commandline --replace ''
      else
         commandline -f execute
      end
   end

   starship init fish | source
   fzf --fish | source

   set fish_greeting ""
   set -g fish_color_autosuggestion b0b0b0
end

if not contains /opt/homebrew/bin $PATH
   eval "$(/opt/homebrew/bin/brew shellenv)"
end

# Aliases
alias fzr="fzf --preview='cat {}' --preview-window=right:60%"
alias dev='set dir (ls $HOME/Developer | fzf --height=20%); test -n "$dir"; cd $HOME/Developer/$dir'
alias sys-fzf='cd / && fzf --bind=\'enter:execute(bash -c "yazi {}")\'; cd $HOME'
alias brew-clean='brew cleanup; brew cleanup -s; brew cleanup --prune=all; rm -rf (brew --cache)'
alias poke-fzf='cd $SCRIPTS_DIR/pokemon_sprites; ls | fzr --preview="cat {}"; cd $HOME'
alias pokemon_sprite='$SCRIPTS_DIR/pokemon_sprite.sh'
alias ascii='java -cp $HOME/Developer/ascii-image-generator/bin CLI'
alias java_run='$SCRIPTS_DIR/java_run.sh'
alias git-proj-init='cp -r $HOME/Developer/_git_template/* .'
alias clear='clear && pokemon_sprite; echo -e "\r"'
