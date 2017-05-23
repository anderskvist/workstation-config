#!/bin/bash
ID=$(cat /var/lib/dbus/machine-id)
case ${ID} in
    618215eaded54b138cce9aa1c8b9a0b5)
	# Lenovo Thinkpad X1 Carbon
	EXTERNAL_OUTPUT="DP-1-2"
	INTERNAL_OUTPUT="eDP-1"
	;;
    unknown)
	# Dell XPS 15
	EXTERNAL_OUTPUT="DP1"
	INTERNAL_OUTPUT="eDP1"
	;;
esac

# if we don't have a file, start at zero
if [ ! -f "/tmp/monitor_mode.dat" ] ; then
  monitor_mode="all"

# otherwise read the value from the file
else
  monitor_mode=`cat /tmp/monitor_mode.dat`
fi

if [ $monitor_mode = "all" ]; then
        monitor_mode="EXTERNAL"
        xrandr --primary --output $INTERNAL_OUTPUT --off --output $EXTERNAL_OUTPUT --auto
elif [ $monitor_mode = "EXTERNAL" ]; then
        monitor_mode="INTERNAL"
        xrandr --primary --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --off
elif [ $monitor_mode = "INTERNAL" ]; then
        monitor_mode="CLONES"
        xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --same-as $INTERNAL_OUTPUT
else
        monitor_mode="all"
        xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --left-of $INTERNAL_OUTPUT
fi
echo "${monitor_mode}" > /tmp/monitor_mode.dat

