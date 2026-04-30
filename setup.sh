#!/usr/bin/env bash

### ------------------------------------ Variables ----------------------------------- ###

PACKAGES="flatpak pdftk python3-pip zathura zathura-pdf-mupdf bat imv task
kitty zsh zsh-syntax-highlighting fzf fastfetch mesa-libOpenCL clinfo evince
simple-scan keepassxc mate-calc syncthing mediawriter nemo dunst brightnessctl
gtk-murrine-engine gtk3-devel fuse fuse-libs cups cups-filters pavucontrol"

HYPRLAND="hyprland hyprpaper sddm hyprland-devel rofi-wayland wlsunset
xdg-desktop-portal-hyprland"

HYPRPM="cmake meson gcc-c++ hyprlang-devel hyprcursor-devel mesa-libgbm-devel libdrm-devel
mesa-libGLES-devel hyprutils-devel aquamarine-devel wayland-devel pango-devel
hyprgraphics-devel tomlplusplus-devel systemd-devel socat cairo-devel pixman-devel
glib2-devel re2-devel libinput-devel libxkbcommon-devel libuuid-devel libXcursor-devel
xcb-util-errors-devel wayland-protocols-devel udis86-devel hyprwayland-scanner-devel
xcb-util-wm-devel muParser-devel hyprwire-devel"

SDDMTHEME="qt6-qt5compat qt5-qtgraphicaleffects qt5-qtquickcontrols2"
OFFICE="libreoffice-calc libreoffice-gtk3 darktable web-eid hexchat firefox"

LATEX="texlive-scheme-basic latexmk texlive-bibtex8 texlive-standalone texlive-preview
texlive-mathtools texlive-babel-german texlive-multirow texlive-eurosym texlive-spreadtab
texlive-numprint texlive-textpos texlive-tcolorbox texlive-qrcode texlive-datetime2
texlive-datetime2-german texlive-hyphen-german texlive-xskak texlive-skak texlive-skaknew
texlive-collection-fontsrecommended texlive-doi texlive-mdframed texlive-fontawesome5
texlive-ebgaramond texlive-datetime2-english"

EXTERNAL="google-chrome-stable sublime-text synology-drive-noextra"

DESKTOP="easyeffects"
LAPTOP="tlp light"

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

# Sublime Text
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager addrepo \
	--from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

# Rpm Fusion
# Fedora omits H.264/H.265 for patent reasons -- the freeworld Mesa drivers supply
# these codecs, otherwise hardware decoding falls back to software (CPU)
sudo dnf -y install \
	$RPMFUSION/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

### --------------------------------- DNF Packages ---------------------------------- ###

# Bootstrap: needed for the Google Chrome repo file
sudo dnf -y install fedora-workstation-repositories redhat-rpm-config
sudo dnf config-manager setopt google-chrome.enabled=1

sudo dnf -y upgrade
sudo dnf --refresh -y install \
	$PACKAGES $SDDMTHEME $HYPRPM $HYPRLAND $LATEX $OFFICE $EXTERNAL

if [ "$IS_LAPTOP" = true ]
then
	sudo dnf -y install $LAPTOP
	sudo hostnamectl set-hostname carthy
	sudo systemctl enable tlp.service
	cp ./hypr/device-laptop.conf ~/.config/hypr/device.conf
else
	sudo dnf -y install $DESKTOP
	sudo hostnamectl set-hostname thyrium
	cp ./hypr/device-desktop.conf ~/.config/hypr/device.conf
fi

# H.264/H.265 hardware decoding -- replaces Fedora's restricted build with RPM Fusion
sudo dnf -y install mpv ffmpeg-libs --allowerasing
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

# Pomotroid (latest RPM from GitHub releases)
POMOTROID_URL=$(curl -s https://api.github.com/repos/Splode/pomotroid/releases/latest \
	| grep "browser_download_url.*x86_64\.rpm" | cut -d'"' -f4)
sudo dnf -y install "$POMOTROID_URL"

# Rpms
# sudo dnf -y install ./rpms/*

### --------------------------------- Flatpak Apps ---------------------------------- ###

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Global theme overrides
sudo flatpak override --filesystem=$HOME
sudo flatpak override --env=GTK_THEME=mathy
sudo flatpak override --env=ICON_THEME=Newaita-reborn-deep-purple-dark

# Signal
sudo flatpak install -y flathub org.signal.Signal
sudo flatpak override --user --env=PULSE_LATENCY_MSEC=30 org.signal.Signal
sudo flatpak override --user --env=ELECTRON_OZONE_PLATFORM_HINT=auto org.signal.Signal

# Spotify
sudo flatpak install -y flathub com.spotify.Client

# Actual Budget
sudo flatpak install -y flathub org.actualbudget.Actual
flatpak override --user --filesystem=xdg-config/Actual org.actualbudget.Actual
flatpak override --user --filesystem=xdg-data/Actual org.actualbudget.Actual

# Watson
pip install --user td-watson

### ------------------------------- System Settings --------------------------------- ###

# Grub
sudo grub2-editenv - set menu_auto_hide=1
if [ -d /boot/efi ]
then
	sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
else
	sudo grub2-mkconfig -o /boot/grub2/grub.cfg
fi

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

# Gtk File Chooser ( current working directory )
gsettings set org.gtk.Settings.FileChooser startup-mode cwd

# Default applications
xdg-mime default sublime_text.desktop text/x-tex
xdg-mime default sublime_text.desktop text/csv

# Services
systemctl --user enable syncthing.service
sudo updatedb

### --------------------------------- User Settings --------------------------------- ###

# Git
git config --global user.email "thyriaen@googlemail.com"
git config --global user.name "Carlisle Nightingale"

# SSH
ssh-keygen

### ----------------------------------- Copy Files ---------------------------------- ###

# SDDM
sudo mkdir -p /usr/share/sddm/themes/
sudo cp ./sddm.conf /etc/
sudo cp -r ./sddm/eucalyptus-drop /usr/share/sddm/themes/
sudo cp ./sddm/theme.conf /usr/share/sddm/themes/eucalyptus-drop/

# Binaries
sudo cp -r ./bin/* /usr/local/bin/
cp -r ./localbin/* ~/.local/bin/

# Global configs
sudo cp -r ./usrshare/* /usr/share/

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
if [ ! -d ~/.config/powerlevel10k ]
then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
fi
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh

# Dotfiles
cp ./home/.[!.]* ~/

# Wallpaper
mkdir -p ~/Pictures/Wallpapers
if [ "$IS_LAPTOP" = true ]
then
	cp ./usrshare/backgrounds/wpMoonLaptop.png ~/Pictures/Wallpapers/wpMoon.png
else
	cp ./usrshare/backgrounds/wpMoon.png ~/Pictures/Wallpapers/wpMoon.png
fi

# Applications
mkdir -p ~/.local/share/applications
cp ./apps/*.desktop ~/.local/share/applications
