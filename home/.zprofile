if [[ -z "${WAYLAND_DISPLAY:-}" ]] && uwsm check may-start -q; then
  export THY_AUTOLOGIN_LOCK=1
  uwsm_log_dir="${XDG_STATE_HOME:-$HOME/.local/state}/uwsm"
  mkdir -p "$uwsm_log_dir"
  printf '\033c'
  exec uwsm start -e -D Hyprland hyprland.desktop >>"$uwsm_log_dir/autologin.log" 2>&1
fi
