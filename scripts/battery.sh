#!/bin/bash

exit

export STATUS=$(cat /sys/class/power_supply/BAT0/status)
export CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
export BATTINFO=$(acpi -b)


if [ "${STATUS}" = "Discharging" ]; then
    # BEEP
    if [ ${CAPACITY} -lt 5 ]; then
	# Run scripts in ~/bin/battery.d/ to notify of low battery
	run-parts ~/bin/battery.d/
    fi

    # Display notification
    if [ ${CAPACITY} -lt 10 ]; then
        DISPLAY=:0.0 /usr/bin/notify-send -i battery-empty -u critical "Battery critical!" "${BATTINFO}"
    elif [ ${CAPACITY} -lt 25 ]; then
        DISPLAY=:0.0 /usr/bin/notify-send -i battery-low -u normal "Battery warning!" "${BATTINFO}"
    fi
fi
