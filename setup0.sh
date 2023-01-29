
PACKAGES="fedora-workstation-repositories redhat-rpm-config sqlite flatpak
neofetch pdftk python3-pip xsetroot xclip redshift
zathura zathura-pdf-mupdf mediawriter
polybar kitty rofi zsh zsh-syntax-highlighting fzf
evince simple-scan hexchat keepassxc syncthing 
gtk-murrine-engine gtk3-devel 
sddm qt5-qtgraphicaleffects qt5-qtquickcontrols2 qt5-qtsvg picom
"

# xdg-desktop-portal-wlr mate-calc
# Already installed: maim ImageMagick poppler-utils gnome-disk-utility feh dunst 
# xdg-desktop-portal-gtk

# Install basics
sudo dnf -y upgrade
sudo dnf --refresh -y install $PACKAGES

