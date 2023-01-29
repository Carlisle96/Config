

read -r -p "Install laptop version? [y/N]: " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
	# Laptop Only section
	sudo dnf -y install tlp light
	hostnamectl set-hostname carthy
	sudo systemctl enable tlp.service
else
	hostnamectl set-hostname thyrium
fi


sudo systemctl disable lightdm
sudo systemctl enable sddm

