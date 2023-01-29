DEPENDENCIES="stack libX11-devel libXft-devel libXinerama-devel libXrandr-devel 
libXScrnSaver-devel"

sudo dnf -y install $DEPENDENCIES

cd ~/.config/xmonad

git clone --branch v0.17.1 https://github.com/xmonad/xmonad
git clone --branch v0.17.1 https://github.com/xmonad/xmonad-contrib

stack init
stack install