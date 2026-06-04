#!/usr/bin/env bash

set -Eeuo pipefail

socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

thyachieve-layout-auto >/dev/null 2>&1 || true

socat -U - "UNIX-CONNECT:$socket" |
  rg --line-buffered '^(workspace|focusedmon|openwindow|closewindow|movewindow|changefloatingmode)>>' |
  while read -r _; do
    thyachieve-layout-auto >/dev/null 2>&1 || true
  done &
disown
