#!/bin/sh

CURRENT=$(xbacklight)

case $1 in
    dec)
	NEW=$(echo ${CURRENT}/2|bc -l)
	;;
    inc)
	NEW=$(echo ${CURRENT}*2|bc -l)
	;;
    *)
	NEW=${CURRENT}
	;;
esac

NEW=$(printf '%.*f\n' 0 ${NEW})

if [ ${NEW} -lt 1 ]; then
    NEW=1
fi

xbacklight -time 100 -steps 25 -set ${NEW}
#ISPLAY=:0.0 /usr/bin/notify-send -i display-brightness -u normal "${NEW}"%
