
PACKAGES="fedora-workstation-repositories redhat-rpm-config sqlite 
neofetch pdftk python3-pip xsetroot maim xclip 
ImageMagick zathura zathura-pdf-mupdf poppler-utils
polybar feh kitty rofi zsh zsh-syntax-highlighting fzf dunst xdg-desktop-portal-wlr
evince mate-calc simple-scan hexchat keepassxc syncthing synology-drive-noextra
gtk-murrine-engine gtk3-devel lxappearance
"
# Install basics
sudo dnf -y upgrade
sudo dnf -y copr enable emixampp/synology-drive
sudo dnf --refresh -y install $PACKAGES
sudo dnf -y remove xmobar i3 awesome ratpoison openbox xdg-desktop-portal-gtk

# sudo dnf -y remove lightdm
# sudo dnf -y install lxdm
# systemctl enable lxdm

# Laptop Only section
sudo dnf -y install tlp light
hostnamectl set-hostname carthy
sudo systemctl enable tlp.service

# Sublime Text
sudo dnf -y config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf -y install sublime-text
mkdir -p ~/.config/sublime-text/Packages/User/
cp ./cfg/sublime/* ~/.config/sublime-text/Packages/User/

# Chrome
sudo dnf -y config-manager --set-enabled google-chrome
sudo dnf -y install google-chrome-stable

# Binaries
cp -r ./bin/* ~/.local/bin/

# Watson
pip install td-watson

# Configs
sudo systemctl --user enable syncthing.service
sudo systemctl --user start syncthing.service
# sudo grub2-editenv - set menu_auto_hide=1
# sudo grub2-mkconfig

# Find utils
sudo updatedb

# Terminal
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty

# nnn
mkdir -p ~/.config/nnn/plugins
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
cp ./cfg/nnn/plugins/drag ~/.config/nnn/plugins/

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
flatpak install flathub org.signal.Signal

# Putting files at locations
mkdir -p ~/.xmonad/hooks/
cp ./home/profile ~/.profile
cp ./home/startup.sh ~/.xmonad/hooks/
cp ./xmonad/xmonad.hs ~/.xmonad/xmonad.hs
cp ./home/zshrc ~/.zshrc
cp ./home/p10k.zsh ~/.p10k.zsh
sudo cp ./home/lightdm-gtk-greeter.conf /etc/lightdm/

mkdir -p ~/.themes
cp -r ./themes/* ~/.themes/
sudo cp -r ~/.themes/mathy /usr/share/themes/

mkdir -p ~/.local/share/fonts/
sudo cp -r ./fonts/* /usr/share/fonts/

# Keyboard
sudo cp ./xkb/thy /usr/share/X11/xkb/symbols/
sudo cp ./xkb/evdev.xml /usr/share/X11/xkb/rules/

mkdir -p ~/Pictures/Wallpapers
cp ./Wallpaper.jpeg ~/Pictures/Wallpapers/
sudo mkdir -p /usr/share/backgrounds/
sudo cp ./Wallpaper.jpeg /usr/share/backgrounds/

mkdir -p ~/.local/share/applications
cp ./apps/*.desktop ~/.local/share/applications


sudo cp -r ./icons/* /usr/share/icons/

cp -r ./cfg/gtk-3.0/ ~/.config/
cp -r ./cfg/zathura/ ~/.config/
cp -r ./cfg/kitty ~/.config/
cp -r ./cfg/hexchat ~/.config/
cp -r ./cfg/polybar ~/.config/
cp -r ./cfg/rofi ~/.config/
cp -r ./cfg/dunst ~/.config/ 
cp -r ./cfg/keepassxc ~/.config/

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


