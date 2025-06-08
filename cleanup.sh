rm ~/.bash*

hyprpm update
hyprpm add https://github.com/zakk4223/hyprNStack
hyprpm enable hyprNStack
cp -r ./hypr/* ~/.config/hypr/

fstabstring="
UUID=75868785-af97-4b46-a511-1b7122e54953 /home/thyriaen/Data	   ext4	 defaults 	0 0
UUID=3baa35ef-d65e-435a-827b-e6166993d36e /home/thyriaen/Documents ext4	 defaults 	0 0"