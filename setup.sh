
PACKAGES="fedora-workstation-repositories redhat-rpm-config sqlite flatpak
neofetch pdftk python3-pip xsetroot maim xclip redshift
ImageMagick zathura zathura-pdf-mupdf poppler-utils gnome-disk-utility mediawriter
polybar feh kitty rofi zsh zsh-syntax-highlighting fzf dunst xdg-desktop-portal-wlr
evince mate-calc simple-scan hexchat keepassxc syncthing synology-drive-noextra
gtk-murrine-engine gtk3-devel
sddm qt5-qtgraphicaleffects qt5-qtquickcontrols2 qt5-qtsvg picom
"

# Install basics
sudo dnf -y upgrade
sudo dnf -y copr enable emixampp/synology-drive
sudo dnf --refresh -y install $PACKAGES
# xdg-desktop-portal-gtk


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


# TODO for non-Laptop -- different background in sddm // different config


sudo systemctl disable lightdm
sudo systemctl enable sddm

sudo dnf -y remove xmobar i3 awesome ratpoison openbox lightdm


# Sublime Text
sudo dnf -y config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf -y install sublime-text
mkdir -p ~/.config/sublime-text/Packages/User/
cp ./cfg/sublime/* ~/.config/sublime-text/Packages/User/

# Chrome
sudo dnf -y config-manager --set-enabled google-chrome
sudo dnf -y install google-chrome-stable

# Watson
pip install td-watson

# Configs
systemctl --user enable syncthing.service
sudo grub2-editenv - set menu_auto_hide=1
sudo grub2-mkconfig

# Find utils
sudo updatedb

# Terminal
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty



# fff filepicker
sudo cp ./cfg/filechooser/xdg-desktop-portal-termfilechooser.service /etc/systemd/system/
# sudo mkdir -p /usr/local/lib/systemd/user/
# sudo cp ./cfg/filechooser/xdg-desktop-portal-termfilechooser.service /usr/local/lib/systemd/user/
sudo cp ./cfg/filechooser/termfilechooser.portal /usr/share/xdg-desktop-portal/portals/
# sudo mkdir -p /usr/local/share/xdg-desktop-portal/portals/
# sudo cp ./cfg/filechooser/termfilechooser.portal /usr/local/share/xdg-desktop-portal/portals/
mkdir -p ~/.config/xdg-desktop-portal-termfilechooser/
cp ./cfg/filechooser/config ~/.config/xdg-desktop-portal-termfilechooser/
cp ./cfg/filechooser/fff.sh ~/.config/xdg-desktop-portal-termfilechooser/

# or this
# sudo dnf -y install xdg-desktop-portal-gtk
# gsettings set org.gtk.Settings.FileChooser startup-mode cwd

# Signal
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=$HOME/.icons
sudo flatpak override --env=GTK_THEME=mathy
sudo flatpak override --env=ICON_THEME=Newaita-reborn-deep-purple-dark
sudo flatpak install flathub org.signal.Signal

# Putting files at locations
sudo cp ./sddm.conf /etc/
sudo mkdir -p /usr/share/sddm/themes/
sudo cp -r ./sugar-candy /usr/share/sddm/themes/
mkdir -p ~/.xmonad/hooks/
cp ./home/gtkrc-2.0 ~/.gtkrc-2.0
cp ./home/profile ~/.profile
cp ./home/startup.sh ~/.xmonad/hooks/
cp ./xmonad/xmonad.hs ~/.xmonad/xmonad.hs
cp ./home/zshrc ~/.zshrc
cp ./home/p10k.zsh ~/.p10k.zsh

mkdir -p ~/.themes 
cp -r ./themes/mathy ~/.themes/
sudo cp -r ./themes/mathy /usr/share/themes/

mkdir -p ~/.local/share/fonts/
sudo cp -r ./fonts/* /usr/share/fonts/

# Keyboard
sudo cp ./xkb/thy /usr/share/X11/xkb/symbols/
sudo cp ./xkb/evdev.xml /usr/share/X11/xkb/rules/

# todo laptop wallpaper
mkdir -p ~/Pictures/Wallpapers
cp ./Wallpaper.jpeg ~/Pictures/Wallpapers/
sudo mkdir -p /usr/share/backgrounds/
sudo cp ./Wallpaper.jpeg /usr/share/backgrounds/

mkdir -p ~/.local/share/applications
cp ./apps/*.desktop ~/.local/share/applications

mkdir -p ~/.icons
sudo cp -r ./icons/* /usr/share/icons/
cp -r ./icons/* /usr/share/icons/

cp -r ./cfg/default ~/.config/
cp -r ./cfg/gtk-3.0 ~/.config/
cp -r ./cfg/zathura ~/.config/
cp -r ./cfg/kitty ~/.config/
cp -r ./cfg/hexchat ~/.config/
cp -r ./cfg/polybar ~/.config/
cp -r ./cfg/rofi ~/.config/
cp -r ./cfg/dunst ~/.config/ 
cp -r ./cfg/keepassxc ~/.config/
cp -r ./cfg/picom ~/.config/

# Binaries
sudo cp -r ./bin/* /bin/

# nnn
mkdir -p ~/.config/nnn/plugins
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
cp ./cfg/nnn/plugins/drag ~/.config/nnn/plugins/

xdg-mime default sublime_text.desktop text/x-tex

ssh-keygen
git config --global user.email "thyriaen@googlemail.com"
git config --global user.name "Carlisle Nightingale"

rm ~/.bash*


# RealTodo

# Todo
# install fzf keybindings
# pip command line completen guide tailordev.github.io/Watson/
# sublime - hide menu - hide minimap
# lxdm greeter setup


