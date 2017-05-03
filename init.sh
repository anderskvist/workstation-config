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

# install openvpn helper script
git clone git@github.com:anderskvist/openvpn-script.git ~/Projects/openvpn-script
ln -sf ~/Projects/openvpn-script/openvpn.sh ~/bin/
