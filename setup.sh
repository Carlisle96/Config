sudo dnf install redhat-rpm-config alacritty vis rofi zsh git zsh-syntax-highlighting fzf
sudo dnf install tlp
sudo dnf remove i3 awesome ratpoison openbox xterm
wget https://github.com/minbrowser/min/releases/download/v1.25.1/min-1.25.1-x86_64.rpm
sudo dnf install ./min-1.25.1-x86_64.rpm
hostnamectl set-hostname thymonad

-- todo: dotfiles holen
fonts holen
install fzf keybindings
set zsh as default shell
flicker free boot

/usr/share/X11/xkb/
