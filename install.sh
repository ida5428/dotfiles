#!/usr/bin/env bash

# Exit immediately if any command fails
set -e

CYAN='\033[1;36m'
YELLOW='\033[93m'
RESET='\033[0m'

echo -e "\n${CYAN}Changing MacOS Settings...${RESET}"
touch "$HOME/.hushlogin"
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.35
defaults write -g NSWindowShouldDragOnGesture -bool true
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
killall Dock

echo -e "\n${CYAN}Installing Homebrew...${RESET}"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo -e "\n${CYAN}Adding Homebrew to PATH...${RESET}"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo -e "\n${CYAN}Install Homebrew packages...${RESET}"
brew bundle --global

echo -e "\n${CYAN}Sourcing .zshrc...${RESET}"
echo "[[ -f \"$HOME/.config/zsh/zshrc\" ]] && source \"$HOME/.config/zsh/zshrc\"" >> "$HOME/.zshrc" && source "$HOME/.zshrc"

echo -e "\n${CYAN}Creating and loading LaunchAgent...${RESET}"
cat > "$HOME/Library/LaunchAgents/com.forceinput.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
   <dict>
   <key>Label</key>
   <string>com.forceinput</string>
   <key>ProgramArguments</key>
   <array>
      <string>/Users/adityaverma/.config/scripts/swift/ForceInput</string>
   </array>
   <key>RunAtLoad</key>
   <true/>
   <key>KeepAlive</key>
   <true/>
   </dict>
</plist>
EOF
launchctl load "$HOME/Library/LaunchAgents/com.forceinput.plist"

echo -e "\n${CYAN}Run the following command to stop the LaunchAgent:${RESET}"
echo -e "\t${YELLOW}launchctl unload $HOME/Library/LaunchAgents/com.forceinput.plist${RESET}"

echo -e "\n${CYAN}Run the following commands to configure Git...${RESET}"
echo -en "${YELLOW}"
cat <<'EOF'
        ssh-keygen -t ed25519 -C "207427661+ida5428@users.noreply.github.com"

        git config --global user.name "ida5428"
        git config --global user.email "207427661+ida5428@users.noreply.github.com"
        git config --global user.signingkey $HOME/.ssh/id_ed25519

        git config --global gpg.format ssh
        git config --global commit.gpgsign true
        git config --global credential.helper osxkeychain
        git config --global init.defaultBranch main
EOF
echo -en "${RESET}"

echo -e "\n${CYAN}Run the following command to symlink openJDK-21:${RESET}"
echo -e "\t${YELLOW}sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk@21.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk${RESET}"

echo -e "\n${CYAN}Run the following command to set Zed as the default editor:${RESET}"
echo -en "${YELLOW}"
cat <<'EOF'
        for uti in \
          public.plain-text \
          public.text \
          public.source-code \
          public.script \
          public.xml \
          public.json \
          net.daringfireball.markdown \
          public.comma-separated-values-text \
          public.data \
          public.rtf \
          com.apple.property-list \
          public.yaml
        do
          duti -s dev.zed.Zed "$uti" all
        done
EOF
echo -en "${RESET}"

