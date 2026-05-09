#!/usr/bin/env bash

set -Eeuo pipefail

printf 'Desktop mount reference: ./desktop-fstab.example\n'
hyprpm update

if ! hyprpm list 2>/dev/null | grep -q 'hyprNStack'
then
	hyprpm add https://github.com/zakk4223/hyprNStack
fi

hyprpm enable hyprNStack
mkdir -p ~/.config/hypr
cp -r ./hypr/. ~/.config/hypr/
