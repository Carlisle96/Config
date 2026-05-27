#!/usr/bin/env bash

set -Eeuo pipefail
trap 'echo "ERROR: firefox.sh failed at line $LINENO" >&2' ERR

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
FIREFOX_DIR="$HOME/.mozilla/firefox"
PROFILES_INI="$FIREFOX_DIR/profiles.ini"

if [ ! -f "$PROFILES_INI" ]
then
	echo "Firefox profile not found. Start Firefox once, close it, then run this script again." >&2
	exit 1
fi

profile_path="$(
	awk '
		BEGIN { section = ""; install_default = ""; profile_default = ""; profile_path = ""; current_path = "" }
		/^\[/ {
			if (section ~ /^\[Profile/ && current_default == "1" && profile_default == "") {
				profile_default = current_path
			}
			section = $0
			current_path = ""
			current_default = ""
			next
		}
		section ~ /^\[Install/ && /^Default=/ {
			install_default = substr($0, 9)
		}
		section ~ /^\[Profile/ && /^Path=/ {
			current_path = substr($0, 6)
		}
		section ~ /^\[Profile/ && /^Default=1$/ {
			current_default = "1"
		}
		END {
			if (section ~ /^\[Profile/ && current_default == "1" && profile_default == "") {
				profile_default = current_path
			}
			if (install_default != "") print install_default
			else if (profile_default != "") print profile_default
		}
	' "$PROFILES_INI"
)"

if [ -z "$profile_path" ]
then
	echo "Could not determine Firefox default profile from $PROFILES_INI" >&2
	exit 1
fi

profile_dir="$FIREFOX_DIR/$profile_path"
if [ ! -d "$profile_dir" ]
then
	echo "Firefox profile directory does not exist: $profile_dir" >&2
	exit 1
fi

cp "$REPO_DIR/mozilla/user.js" "$profile_dir/user.js"
mkdir -p "$profile_dir/chrome"
cp -r "$REPO_DIR/mozilla/chrome/." "$profile_dir/chrome/"

mkdir -p "$HOME/.mozilla/native-messaging-hosts"
cp -r "$REPO_DIR/mozilla/native-messaging-hosts/." "$HOME/.mozilla/native-messaging-hosts/"

echo "Installed Firefox settings to $profile_dir"
