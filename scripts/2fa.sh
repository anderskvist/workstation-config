#!/bin/bash

WORKDIR=~/.2fa
CONFIG=${WORKDIR}/config.sh

function bail () {
	echo ${*}
	exit -1
}

# Test if configuration file is present - if not, write one
test -f ${CONFIG} || {
	cat > ${CONFIG} << EOF
EMAIL=your@email
KEYID=your_key_id
REMOVE_THIS_LINE=please
EOF
	bail "Config file missing, we written a template for you here: ${CONFIG}"
}

# Read configuration
source ${CONFIG}

# Test if configuration is edited
test -z "${REMOVE_THIS_LINE+x}" || bail "Please edit your configuration file (${CONFIG}) and try again..."

# Arguments
NAME=${1}
COMMAND=${2:-view}

test -z "${NAME}" && bail "Usage: ${0} name [view|edit]"

case "${COMMAND}" in
	view)
		FILE=${WORKDIR}/${NAME}/.key.gpg
		test -f ${FILE} || bail "2FA Missing for ${NAME}"

		# Decrypt token
		TOTP=$(cat ${FILE} |gpg --quiet -u ${KEYID} -r ${EMAIL} -d)

		# Calculate lifespan of 2FA code
		LIFESPAN=$((30-(10#$(date +%S)%30)))

		# Find 2FA code
		CODE=$(oathtool -b --totp ${TOTP})

		echo "2FA code for ${NAME} is:"

		if [ ${LIFESPAN} -lt 5 ]; then
			COLOR="\e[31m"
		elif [ ${LIFESPAN} -lt 10 ]; then
			COLOR="\e[93m"
		else
			COLOR="\e[92m"
		fi

		echo -e "${COLOR}${CODE} (lifespan: ${LIFESPAN} seconds)\e[0m"
		if [ -x "$(command -v xclip)" ]; then
			echo -n ${CODE} | xclip
			echo "Code has been added to clipboard - use middle button or shift-insert to paste."
		fi
		;;
	edit)
		echo 'echo -n "KeYhErE......" | gpg -e -r gpg-key > .2fa/${NAME}/.key.gpg'
		bail "TODO"
		;;
	list)
		find ${WORKDIR}/ -name \.key.gpg|rev|cut -d"/" -f2|rev
		;;
	*)
		bail "Command not implemented"
		;;
esac
