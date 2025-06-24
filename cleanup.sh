rm ~/.bash*

hyprpm update
hyprpm add https://github.com/zakk4223/hyprNStack
hyprpm enable hyprNStack
cp -r ./hypr/* ~/.config/hypr/

fstabstring="
UUID=d459de50-ebe4-4e64-9b63-a65b80d18ba6 /home/thyriaen/Data	   ext4	 defaults 	0 0
UUID=3baa35ef-d65e-435a-827b-e6166993d36e /home/thyriaen/Documents ext4	 defaults 	0 0"