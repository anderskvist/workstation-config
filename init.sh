SPOOL=/var/spool/${USER}-workstation-config/
sudo mkdir -p ${SPOOL}
sudo chown ${USER}:${GROUPS} ${SPOOL}

mkdir -p ~/bin/

# i3wm
sudo apt-get -f install \
	i3-wm \
	scrot \
	udiskie \
	numlockx \
	i3status \
	i3lock

mkdir -p ~/.config/i3/
ln -sf ${PWD}/i3/config ~/.config/i3/config
ln -sf ${PWD}/i3/scripts/* ~/bin/

# misc
sudo apt-get -f install \
	emacs-nox \
	openssh-server \
	openvpn \
	git \
	nodejs-legacy \
	npm \
	nmap

# install openvpn helper script
if [ ! -d ~/Projects/openvpn-script ]; then
	git clone git@github.com:anderskvist/openvpn-script.git ~/Projects/openvpn-script
	ln -sf ~/Projects/openvpn-script/openvpn.sh ~/bin/
fi

# chrome
if [ ! -f ${SPOOL}/google-chrome-stable_current_amd64.deb ]; then
	cd ${SPOOL}
	curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	sudo apt-get -f -y install
	cd ~
fi