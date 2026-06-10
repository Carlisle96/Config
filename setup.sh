#!/usr/bin/env bash

set -Eeuo pipefail
trap 'echo "ERROR: setup.sh failed at line $LINENO" >&2' ERR

### ------------------------------------ Variables ----------------------------------- ###

BASICS=(ddcutil grim jq ripgrep slurp socat wireplumber wl-clipboard)

PACKAGES=(
	flatpak pdftk python3-pip zathura zathura-pdf-mupdf bat imv task trash-cli
	kitty zsh zsh-syntax-highlighting fzf fastfetch mesa-libOpenCL clinfo evince
	simple-scan keepassxc mate-calc syncthing mediawriter nemo brightnessctl
	gtk-murrine-engine gtk3-devel fuse fuse-libs cups cups-filters pavucontrol xfce-polkit
)

HYPRLAND=(hyprland sddm xdg-desktop-portal-hyprland hyprpaper wlsunset dunst eww waybar)

SDDMTHEME=(qt6-qt5compat qt5-qtgraphicaleffects qt5-qtquickcontrols2)
OFFICE=(libreoffice-calc libreoffice-gtk3 darktable web-eid hexchat firefox mpv)

LATEX=(
	texlive-scheme-basic latexmk texlive-bibtex8 texlive-standalone texlive-fontawesome5
	texlive-mathtools texlive-babel-german texlive-multirow texlive-eurosym texlive-skak
	texlive-numprint texlive-textpos texlive-tcolorbox texlive-qrcode texlive-datetime2
	texlive-datetime2-german texlive-hyphen-german texlive-xskak  texlive-skaknew
	texlive-collection-fontsrecommended texlive-doi texlive-mdframed  texlive-preview
	texlive-ebgaramond texlive-datetime2-english texlive-koma-script texlive-spreadtab
)

EXTERNAL=(google-chrome-stable sublime-text synology-drive-noextra vicinae zed)

DESKTOP=(easyeffects)
LAPTOP=(tlp light)

RPMFUSION="https://download1.rpmfusion.org"

### ------------------------------ Interactive Setup -------------------------------- ###

read -r -p "Install laptop version? [y/N]: " response
IS_LAPTOP=false
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
	IS_LAPTOP=true
fi

### ------------------------------------- Repos ------------------------------------- ###

# COPRs
# Official Fedora repos ship Hyprland but lag behind -- COPR ensures latest version
sudo dnf -y copr enable sdegler/hyprland
sudo dnf -y copr enable emixampp/synology-drive
sudo dnf -y copr enable quadratech188/vicinae
sudo dnf -y copr enable varlad/eww
sudo dnf -y copr enable che/zed

# Sublime Text
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager addrepo \
	--from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

# Rpm Fusion
sudo dnf -y install "${RPMFUSION}/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"

### --------------------------------- DNF Packages ---------------------------------- ###

# Bootstrap: needed for the Google Chrome repo file
sudo dnf -y install fedora-workstation-repositories redhat-rpm-config
sudo dnf config-manager setopt google-chrome.enabled=1

sudo dnf -y upgrade
sudo dnf --refresh -y install \
	"${BASICS[@]}" "${PACKAGES[@]}" "${SDDMTHEME[@]}" \
	"${HYPRLAND[@]}" "${LATEX[@]}" "${OFFICE[@]}" "${EXTERNAL[@]}"

mkdir -p ~/.local/bin

if [ "$IS_LAPTOP" = true ]
then
	sudo dnf -y install "${LAPTOP[@]}"
	sudo hostnamectl set-hostname carthy
	sudo systemctl enable tlp.service
else
	sudo dnf -y install "${DESKTOP[@]}"
	sudo hostnamectl set-hostname thyrium
fi

# H.264/H.265 hardware decoding -- replaces Fedora's restricted build with RPM Fusion
sudo dnf -y install ffmpeg --allowerasing

# Pomotroid (latest RPM from GitHub releases)
POMOTROID_URL="$(
	curl -fsSL --retry 3 https://api.github.com/repos/Splode/pomotroid/releases/latest \
		| jq -r '.assets[].browser_download_url | select(test("x86_64\\.rpm$"))' \
		| head -n1
)"
if [ -z "$POMOTROID_URL" ]
then
	echo "Could not find latest Pomotroid x86_64 RPM" >&2
	exit 1
fi
sudo dnf -y install "$POMOTROID_URL"

# Rpms
# sudo dnf -y install ./rpms/*

### --------------------------------- Flatpak Apps ---------------------------------- ###

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Global theme overrides
flatpak override --user --filesystem="$HOME"
flatpak override --user --env=GTK_THEME=mathy
flatpak override --user --env=ICON_THEME=Newaita-reborn-deep-purple-dark

# Signal
flatpak install -y flathub org.signal.Signal
flatpak override --user --env=PULSE_LATENCY_MSEC=30 org.signal.Signal
flatpak override --user --env=ELECTRON_OZONE_PLATFORM_HINT=auto org.signal.Signal

# Spotify
flatpak install -y flathub com.spotify.Client

# Actual Budget
flatpak install -y flathub com.actualbudget.actual
flatpak override --user --filesystem=xdg-config/Actual org.actualbudget.actual
flatpak override --user --filesystem=xdg-data/Actual org.actualbudget.actual

# Watson
pip install --user td-watson

### ------------------------------- System Settings --------------------------------- ###

# Login shell
chsh -s /usr/bin/zsh

# Grub
sudo grub2-editenv - set menu_auto_hide=1
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Green vertical flicker fix (desktop only) -- disables AMD GPU runtime power management
if [ "$IS_LAPTOP" = false ]
then
	sudo grubby --update-kernel=ALL --args="amdgpu.runpm=0 amdgpu.gpu_recovery=1"
fi

# SDDM
sudo systemctl enable sddm --force
sudo systemctl set-default graphical.target

# Interface theming
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'mathy'
gsettings set org.gnome.desktop.interface icon-theme 'Newaita-reborn-deep-purple-dark'
gsettings set org.gnome.desktop.interface font-name 'M PLUS 1 Medium 10.5'
gsettings set org.gnome.desktop.interface cursor-theme 'material_light_cursors'
gsettings set org.gnome.desktop.interface accent-color 'purple'

# Default terminal
gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty

# Gtk File Chooser
gsettings set org.gtk.Settings.FileChooser startup-mode cwd
gsettings set org.gtk.Settings.FileChooser show-hidden false
gsettings set org.gtk.Settings.FileChooser sort-column name
gsettings set org.gtk.Settings.FileChooser sort-order ascending
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
gsettings set org.gtk.gtk4.Settings.FileChooser startup-mode cwd
gsettings set org.gtk.gtk4.Settings.FileChooser show-hidden false
gsettings set org.gtk.gtk4.Settings.FileChooser sort-column name
gsettings set org.gtk.gtk4.Settings.FileChooser sort-order ascending
gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true

### --------------------------------- User Settings --------------------------------- ###

# Git
git config --global user.email "thyriaen@googlemail.com"
git config --global user.name "Carlisle Nightingale"

# SSH
if [ ! -f ~/.ssh/id_ed25519.pub ] && [ ! -f ~/.ssh/id_rsa.pub ]
then
	ssh-keygen
fi

### ----------------------------------- Copy Files ---------------------------------- ###

# SDDM
SDDM_THEME_TMP=$(mktemp -d)
git clone --depth=1 \
	https://gitlab.com/Matt.Jolly/sddm-eucalyptus-drop \
	"$SDDM_THEME_TMP/eucalyptus-drop"
sudo mkdir -p /usr/share/sddm/themes/eucalyptus-drop
sudo cp ./sddm/sddm.conf /etc/
sudo cp -r "$SDDM_THEME_TMP/eucalyptus-drop/." /usr/share/sddm/themes/eucalyptus-drop/
sudo cp ./sddm/theme.conf /usr/share/sddm/themes/eucalyptus-drop/
if [ "$IS_LAPTOP" = true ]
then
	sudo install -m 0644 ./usrshare/backgrounds/wpMoonLaptopCorner16.png \
		/usr/share/sddm/themes/eucalyptus-drop/Backgrounds/wpMoon.png
else
	sudo install -m 0644 ./usrshare/backgrounds/wpMoonCorner16.png \
		/usr/share/sddm/themes/eucalyptus-drop/Backgrounds/wpMoon.png
fi
rm -rf "$SDDM_THEME_TMP"

# Binaries
sudo cp -r ./bin/* /usr/local/bin/

# Newaita icon themes
NEWAITA_THEMES=(
	Newaita-reborn-dark
	Newaita-reborn-deep-purple-dark
)
NEWAITA_TMP=$(mktemp -d)
git clone --depth=1 https://github.com/cbrnix/Newaita-reborn "$NEWAITA_TMP/Newaita-reborn"
mkdir -p ~/.icons
for theme in "${NEWAITA_THEMES[@]}"
do
	cp -r "$NEWAITA_TMP/Newaita-reborn/$theme" ~/.icons/
done
rm -rf "$NEWAITA_TMP"

# Global configs
sudo cp -r ./usrshare/* /usr/share/
sudo fc-cache -f /usr/share/fonts
sudo install -D -m 0644 ./mozilla/policies.json /usr/lib64/firefox/distribution/policies.json

# Custom XKB layout -- /etc/xkb/ survives xkeyboard-config package updates
sudo mkdir -p /etc/xkb/symbols /etc/xkb/rules
sudo cp ./xkb/symbols/thy /etc/xkb/symbols/thy
sudo cp ./xkb/rules/evdev.xml /etc/xkb/rules/evdev.xml

# User themes and icons
mkdir -p ~/.themes ~/.icons
cp -r ./usrshare/icons/* ~/.icons/
cp -r ./usrshare/themes/* ~/.themes/

# User configs
cp -r ./cfg/* ~/.config/
cp -r ./local/* ~/.local/
gtk-update-icon-cache -q ~/.local/share/icons/hicolor || true

# Default applications
update-mime-database ~/.local/share/mime
xdg-mime default sublime_text.desktop text/x-tex
xdg-mime default sublime_text.desktop text/csv
xdg-mime default mpv.desktop application/vnd.apple.mpegurl
xdg-mime default mpv.desktop audio/x-mpegurl
xdg-mime default mpv.desktop audio/mpegurl

mkdir -p ~/.config/hypr
cp -r ./hypr/* ~/.config/hypr/

if [ "$IS_LAPTOP" = true ]
then
	cp ./hypr/device-laptop.lua ~/.config/hypr/device.lua
	cp ./hypr/layouts/thylaptop.lua ~/.config/hypr/layouts/thylayout.lua
else
	cp ./hypr/device-desktop.lua ~/.config/hypr/device.lua
fi
if [ ! -d ~/.config/powerlevel10k ]
then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
fi

# NNN
NNN_RELEASE=$(curl -fsSL https://api.github.com/repos/jarun/nnn/releases/latest | python3 -c "import sys,json; print(json.load(sys.stdin)['tag_name'])")
NNN_VERSION=${NNN_RELEASE#v}
NNN_TMP=$(mktemp -d)
curl -fsSL --retry 3 "https://github.com/jarun/nnn/releases/download/${NNN_RELEASE}/nnn-nerd-static-${NNN_VERSION}.x86_64.tar.gz" -o "${NNN_TMP}/nnn.tar.gz"
tar -xzf "${NNN_TMP}/nnn.tar.gz" -C "${NNN_TMP}/"
install -m 0755 "${NNN_TMP}/nnn-nerd-static" ~/.local/bin/nnn
rm -rf "${NNN_TMP}"
curl -fsSL --retry 3 https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
install -D -m 0755 ./cfg/nnn/plugins/drag ~/.config/nnn/plugins/drag

# Dotfiles
cp ./home/.[!.]* ~/

# Wallpaper
mkdir -p ~/Pictures/Wallpapers ~/Pictures/screenshots
if [ "$IS_LAPTOP" = true ]
then
	cp ./usrshare/backgrounds/wpMoonLaptopCorner16.png ~/Pictures/Wallpapers/wpMoon.png
else
	cp ./usrshare/backgrounds/wpMoonCorner16.png ~/Pictures/Wallpapers/wpMoon.png
fi

# Services
systemctl --user daemon-reload
systemctl --user enable syncthing.service
systemctl --user enable vicinae.service
systemctl --user enable thyachieve-progression.timer
systemctl --user enable thyachieve-work.timer
sudo updatedb
