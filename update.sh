#!/usr/bin/env bash

### ------------------------------------ Configs ------------------------------------- ###

# Kitty
cp ~/.config/kitty/kitty.conf ./cfg/kitty/

# Waybar
cp ~/.config/waybar/config ./cfg/waybar/
cp ~/.config/waybar/style.css ./cfg/waybar/

# Sublime Text
cp -r ~/.config/sublime-text/Packages/User/. ./cfg/sublime-text/Packages/User/

### ----------------------------------- Hyprland ------------------------------------- ###

cp -r ~/.config/hypr/. ./hypr/

### ----------------------------------- Dotfiles ------------------------------------- ###

cp ~/.zshrc ./home/
cp ~/.profile ./home/
