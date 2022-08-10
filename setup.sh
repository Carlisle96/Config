sudo dnf upgrade
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo dnf remove i3 awesome ratpoison openbox xterm
sudo dnf copr enable emixampp/synology-drive
sudo dnf --refresh install redhat-rpm-config terminology vis rofi zsh git zsh-syntax-highlighting fzf syncthing dunst sqlite python3-pip xsetroot xclip maim pdftoppm lxappearance synology-drive-noextra
sudo dnf install tlp

sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf install sublime-text

wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo dnf install google-chrome-stable_current_x86_64

hostnamectl set-hostname thymonad

pip install td-watson
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
sudo grub2-editenv - set menu_auto_hide=1
sudo grub2-mkconfig
sudo updatedb
# change in /etc/lightdm/slick-greeter.conf and set slick greeter ofc
# pip command line completen guide tailordev.github.io/Watson/

cp apps/*.desktop ~/.local/share/applications
#cp cfg/terminology ~/.config/terminology/
mkdir ~/Pictures
cp Wallpaper.jpg ~/Pictures

sudo cp xkb/thy /usr/share/X11/xkb/symbols/
sudo cp xkb/evdev.xml /usr/share/X11/xkb/rules/

cp xmonad/xmonad.hs ~/.xmonad/

# /usr/share/X11/xkb/
# flicker free boot
# set zsh as default shell
# install fzf keybindings

#<thyriaen> btw is there a way to define some windows as always floating and assign size and position to them where they should be when i start them ?
#<geekosaur> border is separate from the layout
#<geekosaur> see XMonad.Hooks.ManageHelpers, and the manageHook
#<geekosaur> doRectFloat or doFloatAt
#<geekosaur> you need to know how to match the window, this will vary by app and may be complicated for terminals (watch out for terminal emulator factories)
#* [Leary] has quit (Ping timeout: 245 seconds)
#<geekosaur> also you can't reliably match browser windows, see https://hackage.haskell.org/package/xmonad-contrib-0.17.0/docs/XMonad-Hooks-DynamicProperty.html
#<geekosaur> https://github.com/geekosaur/xmonad.hs/blob/skkukuk/xmonad.hs#L150-L172 example manageHook#

#upower -i /org/freedesktop/UPower/devices/battery_BAT0
# https://www.gnome-look.org/p/1346778/
