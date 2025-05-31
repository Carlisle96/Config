#!/bin/bash
#~/.config/hypr/scripts/nnn-window.sh


# Eingabe: openwindow>>0xADDR,WORKSPACE,CLASS,...
input="${1#openwindow>>}"

# Zerlege die Felder
IFS=',' read -r addr workspace class _ <<< "$input"

# Adresse bereinigen
addr="${addr#0x}"

# Regel: Nur class=nnn darf auf special:nnn bleiben
if [[ "$workspace" == "special:nnn" && "$class" != "nnn" ]]; then
    target_ws=$(hyprctl activeworkspace -j | jq -r '.id')
    hyprctl -q dispatch movetoworkspacesilent "$target_ws",address:"0x$addr"
fi
