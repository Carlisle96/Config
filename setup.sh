### ------------------------------------- Basics ------------------------------------ ###

PACKAGES="fedora-workstation-repositories redhat-rpm-config flatpak 
pdftk python3-pip zathura zathura-pdf-mupdf bat
kitty zsh zsh-syntax-highlighting fzf fastfetch
evince simple-scan hexchat keepassxc mate-calc syncthing mediawriter nemo
gtk-murrine-engine gtk3-devel"  

SDDMTHEME="qt6-qt5compat qt5-qtgraphicaleffects qt5-qtquickcontrols2 qt5-qtsvg"
NONEED="pavucontrol mpv firefox ImageMagick poppler-utils gnome-disk-utility dunst"
UNKNOWN="sqlite libreoffice-calc libreoffice-gtk3"
XMONAD="xmonad xsetroot xclip redshift rofi sddm-x11 picom maim feh xdg-desktop-portal-gtk"

LATEX="texlive-scheme-basic latexmk texlive-bibtex8 texlive-standalone texlive-preview 
texlive-mathtools texlive-babel-german texlive-multirow texlive-eurosym texlive-spreadtab
texlive-numprint texlive-textpos texlive-tcolorbox texlive-qrcode texlive-datetime2
texlive-datetime2-german texlive-hyphen-german texlive-xskak texlive-skak 
texlive-collection-fontsrecommended texlive-skaknew texlive-doi texlive-mdframed
texlive-fontawesome5 texlive-ebgaramond texlive-datetime2-english"

# Install basics
sudo dnf -y upgrade
#sudo dnf -y copr enable solopasha/hyprland
sudo dnf --refresh -y install $PACKAGES $HYPRLAND $LATEX

read -r -p "Install laptop version? [y/N]: " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
	# Laptop Only section
	sudo dnf -y install tlp light
	sudo hostnamectl set-hostname carthy
	sudo systemctl enable tlp.service
	rm ./usrshare/backgrounds/wpMoon.png
	mv ./usrshare/backgrounds/wpMoonLaptop.png ./usrshare/backgrounds/wpMoon.png
else
	hostnamectl set-hostname thyrium
	rm ./usrshare/backgrounds/wpMoonLaptop.png
fi

### ------------------------------------ Flatpak ------------------------------------ ###

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=$HOME/.icons
sudo flatpak override --env=GTK_THEME=mathy
sudo flatpak override --env=ICON_THEME=Newaita-reborn-deep-purple-dark

### ------------------------------ Installing Packages ------------------------------ ###

# Chrome
sudo dnf config-manager setopt google-chrome.enabled=1
sudo dnf -y install google-chrome-stable

# Signal
sudo flatpak install -y flathub org.signal.Signal
sudo flatpak override org.signal.Signal --filesystem=host

# Spotify
sudo flatpak install -y flathub com.spotify.Client

# Planner
# sudo flatpak install -y org.gnome.GTG

# Watson
pip install td-watson

# Sublime Text
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager addrepo \
	--from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo dnf -y install sublime-text

# Synology Drive
sudo dnf -y copr enable emixampp/synology-drive
sudo dnf -y install synology-drive-noextra

# Estonian Software
sudo dnf -y copr enable abn/web-eid
sudo dnf -y install web-eid

# Rpm Fusion
# sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Rpms
# sudo dnf -y install ./rpms/*

### ------------------------------------ Settings ----------------------------------- ###

# Grub
sudo grub2-editenv - set menu_auto_hide=1
sudo grub2-mkconfig

# SDDM
# sudo systemctl enable sddm --force
# sudo systemctl start graphical.target

# Terminal
gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty

# Gtk File Chooser ( current working directory ):
gsettings set org.gtk.Settings.FileChooser startup-mode cwd

# Find utils
sudo updatedb

# Default Applications
xdg-mime default sublime_text.desktop text/x-tex
xdg-mime default sublime_text.desktop text/csv

# Syncthing
systemctl --user enable syncthing.service

# Git
git config --global user.email "thyriaen@googlemail.com"
git config --global user.name "Carlisle Nightingale"

# SSH
ssh-keygen

### ----------------------------------- Copy Files ---------------------------------- ###

# SDDM
# sudo cp ./sddm.conf /etc/

# Binaries
sudo cp -r ./bin/* /bin/
cp -r ./localbin/* ~/.local/bin/

# Global Configs
sudo cp -r ./usrshare/* /usr/share/

mkdir -p ~/.themes
mkdir -p ~/.icons
cp -r ./usrshare/icons/* ~/.icons/
cp -r ./usrshare/themes/* ~/.themes/

# Configs
cp -r ./cfg/* ~/.config/
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh

# Wallpaper
mkdir -p ~/Pictures/Wallpapers
cp ./usrshare/backgrounds/wpMoon.png ~/Pictures/Wallpapers/wpMoon.png

cp ./home/* ~/

# Applications 
mkdir -p ~/.local/share/applications
cp ./apps/*.desktop ~/.local/share/applications


### -------------------------------------- Todo ------------------------------------- ###

# fff filepicker
# sudo cp ./cfg/filechooser/xdg-desktop-portal-termfilechooser.service /etc/systemd/system/
		# sudo mkdir -p /usr/local/lib/systemd/user/
		# sudo cp ./cfg/filechooser/xdg-desktop-portal-termfilechooser.service /usr/local/lib/systemd/user/
# sudo cp ./cfg/filechooser/termfilechooser.portal /usr/share/xdg-desktop-portal/portals/
		# sudo mkdir -p /usr/local/share/xdg-desktop-portal/portals/
		# sudo cp ./cfg/filechooser/termfilechooser.portal /usr/local/share/xdg-desktop-portal/portals/
# mkdir -p ~/.config/xdg-desktop-portal-termfilechooser/
# cp ./cfg/filechooser/config ~/.config/xdg-desktop-portal-termfilechooser/
# cp ./cfg/filechooser/fff.sh ~/.config/xdg-desktop-portal-termfilechooser/

# TODO for non-Laptop -- different background in sddm // different config


# Todo
# install fzf keybindings
# pip command line completen guide tailordev.github.io/Watson/
# sublime - hide menu - hide minimap
# Copy new Icons over to mathy theme

#Todo fstab
