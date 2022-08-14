# Install basics
sudo dnf -y upgrade
sudo dnf -y remove i3 awesome ratpoison openbox
sudo dnf -y copr enable emixampp/synology-drive
sudo dnf --refresh -y install hexchat gtk3-devel ImageMagick zathura zathura-pdf-mupdf keepassxc python3-pip redhat-rpm-config feh nnn kitty vis rofi zsh git zsh-syntax-highlighting fzf syncthing dunst sqlite poppler-utils xsetroot xclip maim lxappearance synology-drive-noextra

# Laptop Only section
sudo dnf -y install tlp

# Sublime Text
sudo dnf -y config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf -y install sublime-text

# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo dnf -y install google-chrome-stable_current_x86_64.rpm

# Watson
pip install td-watson

# Configs
hostnamectl set-hostname carthy
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
git clone https://github.com/mwh/dragon.git
cd dragon
make
cp dragon ~/.local/bin/
cd ..
cp ./cfg/nnn/plugins/drag ~/.config/nnn/plugins/

# and more

# Signal
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.signal.Signal

# Putting files at locations
mkdir -p ~/.xmonad/hooks/
cp home/profile ~/.profile
cp home/startup.sh ~/.xmonad/hooks/
cp home/zshrc ~/.zshrc

mkdir -p ~/.local/share/
mv fonts ~/.local/share/

cp xmonad/xmonad.hs ~/.xmonad/xmonad.hs

sudo cp xkb/thy /usr/share/X11/xkb/symbols/
sudo cp xkb/evdev.xml /usr/share/X11/xkb/rules/

mkdir -p ~/Pictures
cp Wallpaper.jpg ~/Pictures

mkdir -p ~/.local/share/applications
cp apps/*.desktop ~/.local/share/applications

mkdir -p ~/.config/kitty/
cp cfg/kitty/kitty.conf ~/.config/kitty/

# mkdir -p ~/.config/terminology/colorchemes
# cp cfg/terminology/thy.eet ~/.config/terminology/colorchemes/thy.eet

mkdir -p ~/.icons
mv material_light_cursors ~/.icons/

# Useful commands
# upower -i /org/freedesktop/UPower/devices/battery_BAT0

# Manual Install
echo "Install complete"
echo "run lxappreance for manual install now"

# Todo
# set zsh as default shell
# install fzf keybindings
# lightdm greeter
# pip command line completen guide tailordev.github.io/Watson/

#<thyriaen> btw is there a way to define some windows as always floating and assign size and position to them where they should be when i start them ?
#<geekosaur> border is separate from the layout
#<geekosaur> see XMonad.Hooks.ManageHelpers, and the manageHook
#<geekosaur> doRectFloat or doFloatAt
#<geekosaur> you need to know how to match the window, this will vary by app and may be complicated for terminals (watch out for terminal emulator factories)
#* [Leary] has quit (Ping timeout: 245 seconds)
#<geekosaur> also you can't reliably match browser windows, see https://hackage.haskell.org/package/xmonad-contrib-0.17.0/docs/XMonad-Hooks-DynamicProperty.html
#<geekosaur> https://github.com/geekosaur/xmonad.hs/blob/skkukuk/xmonad.hs#L150-L172 example manageHook#


