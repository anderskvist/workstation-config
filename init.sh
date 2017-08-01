SPOOL=/var/spool/${USER}-workstation-config/
sudo mkdir -p ${SPOOL}
sudo chown ${USER}:${GROUPS} ${SPOOL}

mkdir -p ~/bin/

# i3wm
sudo apt-get -y -f install \
	i3-wm \
	scrot \
	udiskie \
	numlockx \
	i3status \
	i3lock \
	acpi \
	xautolock \
	xbacklight \
	dmenu

mkdir -p ~/.config/i3/
ln -sf ${PWD}/i3/config ~/.config/i3/config
ln -sf ${PWD}/i3/scripts/* ~/bin/
sudo cp -f ${PWD}/X11/xorg.conf /etc/X11/xorg.conf

# clusterssh
sudo apt-get -y -f install \
	clusterssh

mkdir -p ~/.clusterssh/
ln -sf ${PWD}/clusterssh/config ~/.clusterssh/config


# misc
sudo apt-get -y -f install \
	emacs-nox \
	openssh-server \
	openvpn \
	git \
	nodejs-legacy \
	npm \
	nmap \
	whois \
	vlc \
	virt-manager \
	resolvconf \
	pwgen \
	php-cli \
	php-elisp \
	php-curl \
	mc \
	screen \
	geeqie \
	curl \
	default-jdk


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

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce python-pip -f -y
sudo pip install docker-compose

# spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install spotify-client
