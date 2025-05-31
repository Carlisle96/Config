#!/bin/sh

handle() {
    case $1 in
    "openwindow"*) ~/.config/hypr/scripts/nnn-window.sh "$1" ;;
    esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock \
  | rg --line-buffered -w 'openwindow' \
  | while read -r line ; do handle "$line" ; done &
disown
