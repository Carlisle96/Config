# Install basics
sudo dnf -y upgrade
sudo dnf -y remove i3 awesome ratpoison openbox
sudo dnf -y copr enable emixampp/synology-drive
sudo dnf --refresh -y install redhat-rpm-config feh nnn alacritty vis rofi zsh git zsh-syntax-highlighting fzf syncthing dunst sqlite python3-pip xsetroot xclip maim lxappearance synology-drive-noextra

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

# Putting files at locations
mkdir -p ~/.xmonad/hooks/
cp home/profile ~/.profile
cp home/startup.sh ~/.xmonad/hooks/
cp home/zshrc ~/.zshrc

cp xmonad/xmonad.hs ~/.xmonad/xmonad.hs

sudo cp xkb/thy /usr/share/X11/xkb/symbols/
sudo cp xkb/evdev.xml /usr/share/X11/xkb/rules/

mkdir -p ~/Pictures
cp Wallpaper.jpg ~/Pictures

mkdir -p ~/.local/share/applications
cp apps/*.desktop ~/.local/share/applications

mkdir -p ~/.config/alacritty/
cp cfg/alacritty/alacritty.yml ~/.config/alacritty/

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


