# Install basics
sudo dnf -y upgrade
sudo dnf -y remove i3 awesome ratpoison openbox
sudo dnf -y copr enable emixampp/synology-drive
sudo dnf --refresh -y install pdftk simple-scan materia-gtk-theme hexchat gtk3-devel ImageMagick zathura zathura-pdf-mupdf keepassxc python3-pip redhat-rpm-config feh kitty rofi zsh git zsh-syntax-highlighting fzf syncthing dunst sqlite poppler-utils xsetroot xclip maim lxappearance synology-drive-noextra

# Laptop Only section
sudo dnf -y install tlp
hostnamectl set-hostname carthy

# Sublime Text
sudo dnf -y config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf -y install sublime-text
mkdir -p ~/.config/sublime-text/Packages/User/
cp ./cfg/sublime/* ~/.config/sublime-text/Packages/User/

# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo dnf -y install google-chrome-stable_current_x86_64.rpm

# Binaries
cp -r ./bin ~/.local/

# Watson
pip install td-watson

# Configs
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
sudo grub2-editenv - set menu_auto_hide=1
sudo grub2-mkconfig
sudo updatedb

# Terminal
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k

# nnn
xdg-mime default org.pwmt.zathura.desktop application/pdf
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
cp ./cfg/nnn/plugins/drag ~/.config/nnn/plugins/

# fff filepicker
sudo cp ./cfg/filechooser/xdg-desktop-portal-termfilechooser.service /etc/systemd/system/
sudo cp ./cfg/filechooser/xdg-desktop-portal-termfilechooser.service /usr/local/lib/systemd/user/
sudo cp ./cfg/filechooser/termfilechooser.portal /usr/share/xdg-desktop-portal/portals/
sudo cp ./cfg/filechooser/termfilechooser.portal /usr/local/share/xdg-desktop-portal/portals/
cp ./cfg/filechooser/config ~/.config/xdg-desktop-portal-termfilechooser/
cp ./cfg/filechooser/fff.sh ~/.config/xdg-desktop-portal-termfilechooser/

# Signal
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.signal.Signal

# Putting files at locations
mkdir -p ~/.xmonad/hooks/
cp ./home/profile ~/.profile
cp ./home/startup.sh ~/.xmonad/hooks/
cp ./home/zshrc ~/.zshrc

mkdir -p ~/.local/share/fonts/
mv ./fonts/* ~/.local/share/fonts/

cp ./xmonad/xmonad.hs ~/.xmonad/xmonad.hs
cp ./home/xmobarrc ~/.xmobarrc 

sudo cp ./xkb/thy /usr/share/X11/xkb/symbols/
sudo cp ./xkb/evdev.xml /usr/share/X11/xkb/rules/

mkdir -p ~/Pictures
cp ./Wallpaper.jpg ~/Pictures

mkdir -p ~/.local/share/applications
cp ./apps/*.desktop ~/.local/share/applications

mkdir -p ~/.config/kitty/
cp ./cfg/kitty/kitty.conf ~/.config/kitty/

mkdir -p ~/.config/zathura/
cp ./cfg/zathura/zathurarc ~/.config/zathura/

mkdir -p ~/.icons
mv ./material_light_cursors ~/.icons/

cp ./cfg/hexchat/colors.conf ~/.config/hexchat

cp -r ./cfg/polybar ~/.config/

# Manual Install
echo " --- Install complete ---"
echo "run lxappreance for manual install now"

# Todo
# set zsh as default shell
# install fzf keybindings
# lightdm greeter
# pip command line completen guide tailordev.github.io/Watson/



