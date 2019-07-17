#!/bin/bash

trap finish EXIT

function finish () {
	# Update background image after resizing screen
	feh --bg-scale /home/akv/.background.png

	# restart xautolock to update coordinates for corners
	xautolock -restart
}

ID=$(cat /var/lib/dbus/machine-id)
case ${ID} in
    d6a597973162428ca880c91c02792f1d|61f2d65eefd7405a9da5ff86251cbd46)
	# Lenovo Thinkpad X1 Carbon I7
	EXTERNAL_OUTPUT="DP2-1"
	INTERNAL_OUTPUT="eDP1"
	;;
    618215eaded54b138cce9aa1c8b9a0b5)
	# Lenovo Thinkpad X1 Carbon I5
	EXTERNAL_OUTPUT="DP-1-2"
	INTERNAL_OUTPUT="eDP-1"
	;;
    943ad03284384bc8b281724a5e2b0b5a)
	# Dell XPS 15
	EXTERNAL_OUTPUT="DP1"
	INTERNAL_OUTPUT="eDP1"
	;;
esac

# For this to work, you will nedd to add the following /etc/udev/rules.d/99-screen-unplug.rules
# ACTION=="change", SUBSYSTEM=="drm", ENV{HOTPLUG}=="1", RUN+="/home/akv/bin/switch_monitor.sh udev"
if [ "${1}" = "udev" ]; then
	export DISPLAY=:0
	export XAUTHORITY=$(ps -C Xorg -f --no-header | sed -n 's/.*-auth //; s/ -[^ ].*//; p')

	xrandr|grep "^${EXTERNAL_OUTPUT} connected" > /dev/null 2>&1
	if [ $? -eq 0 ]; then
	        monitor_mode="EXTERNAL"
		xrandr --output $INTERNAL_OUTPUT --off --output $EXTERNAL_OUTPUT --primary --auto
	        DISPLAY=:0.0 /usr/bin/notify-send -i monitor -u normal "EXTERNAL"
	else
		monitor_mode="INTERNAL"
		xrandr --output $INTERNAL_OUTPUT --primary --auto --output $EXTERNAL_OUTPUT --off
	        DISPLAY=:0.0 /usr/bin/notify-send -i monitor -u normal "INTERNAL"
	fi
	echo "${monitor_mode}" > /tmp/monitor_mode.dat
	exit
fi

# if we don't have a file, start at zero
if [ ! -f "/tmp/monitor_mode.dat" ] ; then
  monitor_mode="all"

# otherwise read the value from the file
else
  monitor_mode=`cat /tmp/monitor_mode.dat`
fi

if [ $monitor_mode = "all" ]; then
        monitor_mode="EXTERNAL"
        xrandr --output $INTERNAL_OUTPUT --off --output $EXTERNAL_OUTPUT --primary --auto
	DISPLAY=:0.0 /usr/bin/notify-send -i monitor -u normal "EXTERNAL"
elif [ $monitor_mode = "EXTERNAL" ]; then
        monitor_mode="INTERNAL"
        xrandr --output $INTERNAL_OUTPUT --primary --auto --output $EXTERNAL_OUTPUT --off
	DISPLAY=:0.0 /usr/bin/notify-send -i monitor -u normal "INTERNAL"
elif [ $monitor_mode = "INTERNAL" ]; then
        monitor_mode="CLONES"
        xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --same-as $INTERNAL_OUTPUT
	DISPLAY=:0.0 /usr/bin/notify-send -i monitor -u normal "CLONE"
else
        monitor_mode="all"
        xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --primary --auto --left-of $INTERNAL_OUTPUT
	DISPLAY=:0.0 /usr/bin/notify-send -i monitor -u normal "ALL"
fi
echo "${monitor_mode}" > /tmp/monitor_mode.dat

