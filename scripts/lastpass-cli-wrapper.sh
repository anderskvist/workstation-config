#!/bin/bash

case ${1} in
	install-desktop-file)
cat > ${HOME}/.local/share/applications/lastpass-cli.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=Lastpass CLI
Exec=${HOME}/bin/lastpass-cli-wrapper.sh
Icon=${HOME}/.local/share/applications/anyconnect.png
Terminal=true
Type=Application
StartupNotify=true
Categories=Shell
EOF
	exit
	;;
esac

echo -n "Enter name: "
read NAME

docker run --rm -ti -v ${HOME}/.lpass/:/root/.lpass/ anderskvist/lastpass-cli lpass show --password ${NAME}

echo "Press enter to close"
read NULL
clear
