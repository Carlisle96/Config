# Install basics
sudo dnf -y upgrade
sudo dnf -y remove i3 awesome ratpoison openbox lightdm xdg-desktop-portal-gtk
sudo dnf -y copr enable emixampp/synology-drive
sudo dnf --refresh -y install dnf-plugins-core xdg-desktop-portal-wlr pdftk evince gtk-murrine-engine mate-calc simple-scan polybar hexchat gtk3-devel ImageMagick zathura zathura-pdf-mupdf keepassxc python3-pip redhat-rpm-config feh kitty rofi zsh zsh-syntax-highlighting fzf syncthing dunst sqlite poppler-utils xsetroot xclip maim lxappearance synology-drive-noextra lxdm

# Laptop Only section
sudo dnf -y install tlp light
hostnamectl set-hostname carthy
systemctl enable tlp.service

systemctl enable lxdm

# Sublime Text
sudo dnf -y config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf -y install sublime-text
mkdir -p ~/.config/sublime-text/Packages/User/
cp ./cfg/sublime/* ~/.config/sublime-text/Packages/User/

# Browser
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf -y install brave-browser

# Binaries
cp -r ./bin ~/.local/

# Watson
pip install td-watson

# Configs
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
# sudo grub2-editenv - set menu_auto_hide=1
# sudo grub2-mkconfig

# Find utils
sudo updatedb

# Terminal
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty

# nnn
cp ./bin/nnn ~/.local/bin
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
cp ./home/zshrc ~/.zshrc

mkdir -p ~/.themes
cp -r ./themes/* ~/.themes/
sudo cp -r ~/.themes/mathy /usr/share/themes/

mkdir -p ~/.local/share/fonts/
cp -r ./fonts/* ~/.local/share/fonts/

cp ./xmonad/xmonad.hs ~/.xmonad/xmonad.hs

sudo cp ./xkb/thy /usr/share/X11/xkb/symbols/
sudo cp ./xkb/evdev.xml /usr/share/X11/xkb/rules/

mkdir -p ~/Pictures/Wallpapers
cp ./Wallpaper.jpeg ~/Pictures/Wallpapers/

mkdir -p ~/.local/share/applications
cp ./apps/*.desktop ~/.local/share/applications

mkdir -p ~/.config/kitty/
cp ./cfg/kitty/kitty.conf ~/.config/kitty/

mkdir -p ~/.config/zathura/
cp ./cfg/zathura/zathurarc ~/.config/zathura/

mkdir -p ~/.icons
cp -r ./material_light_cursors ~/.icons/
sudo cp -r ./material_light_cursors /usr/share/icons/

mkdir -p ~/.config/hexchat/
cp ./cfg/hexchat/colors.conf ~/.config/hexchat/colors.conf

cp -r ./cfg/polybar ~/.config/

ssh-keygen
git config --global user.email "thyriaen@googlemail.com"
git config --global user.name "Carlisle Nightingale"

# Manual Install
echo " --- Install complete ---"
echo "run lxappreance for manual install now"

# Todo
# set zsh as default shell
# install fzf keybindings
# pip command line completen guide tailordev.github.io/Watson/

# lxdm greeter setup


