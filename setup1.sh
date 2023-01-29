
PACKAGES="fedora-workstation-repositories redhat-rpm-config sqlite flatpak
neofetch pdftk python3-pip xsetroot maim xclip redshift
ImageMagick zathura zathura-pdf-mupdf poppler-utils gnome-disk-utility mediawriter
polybar feh kitty rofi zsh zsh-syntax-highlighting fzf dunst xdg-desktop-portal-wlr
evince mate-calc simple-scan hexchat keepassxc syncthing 
gtk-murrine-engine gtk3-devel 
sddm qt5-qtgraphicaleffects qt5-qtquickcontrols2 qt5-qtsvg picom
xdg-desktop-portal-gtk
"

# Install basics
sudo dnf -y upgrade
sudo dnf --refresh -y install $PACKAGES


read -r -p "Install laptop version? [y/N]: " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
	# Laptop Only section
	sudo dnf -y install tlp light
	hostnamectl set-hostname carthy
	sudo systemctl enable tlp.service
else
	hostnamectl set-hostname thyrium
fi


sudo systemctl disable lightdm
sudo systemctl enable sddm

sudo dnf -y remove xmobar i3 awesome ratpoison openbox lightdm
