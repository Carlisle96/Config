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
sudo dnf -y config-manager \
	--add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
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

# Applications 
mkdir -p ~/.local/share/applications
cp ./apps/*.desktop ~/.local/share/applications

