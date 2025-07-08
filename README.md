# MacOS Settings
### Dock:
```zsh
defaults write com.apple.dock autohide-delay -float 0;
defaults write com.apple.dock autohide-time-modifier -float 0.35;
killall Dock
```
---
### Window Drag:
```zsh
defaults write -g NSWindowShouldDragOnGesture -bool true
```
---
### Letter Spam:
```zsh
defaults write -g ApplePressAndHoldEnabled -bool false
```
---
---
# Homebrew
### Install Homebrew:
```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
### Create `Brewfile` at root:
```zsh
echo "
[Brewfile Content]
" > Brewfile
```
### Install everything with:
```zsh
brew bundle
```
---
---
# App Config
## Zed
### Extensions:
- Catppuccin Blur Theme (Mocha)
- Catppuccin Icons (Mocha)
### Run script in `zsh`:
```zsh
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
  duti -s dev.zed.Zed $uti all
done
```
---
## VS Code
### Copy config file to:
```zsh
~/Library/Application Support/Code/User/
```
### Extensions:
- C/C++
- Language Support for Java
- Code Runner
- IntelliCode + API Examples
- Material Icon Theme
---
# Ghostty
```zsh
touch .hushlogin

sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

chmod +x ~/.config/zsh/bonjour
chmod +x ~/.config/zsh/pokemon_sprite
```
---
## `fish`
### Add `fish` to `shell` directory:
```zsh
sudo sh -c 'echo /opt/homebrew/bin/fish >> /etc/shells'
```
## Neovim
### Install `LazyVim`:
```zsh
git clone https://github.com/LazyVim/starter ~/.config/nvim
```
### Remove files at:
```zsh
~/.config/nvim/
```
---
---
