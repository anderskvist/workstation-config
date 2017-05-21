#!/bin/bash

STATUS=$(cat /sys/class/power_supply/BAT0/status)
CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
BATTINFO=$(acpi -b)


if [ "${STATUS}" = "Discharging" ]; then
    if [ ${CAPACITY} -lt 5 ]; then
        DISPLAY=:0.0 /usr/bin/notify-send -i battery-empty -u critical "Battery critical!" "${BATTINFO}"
    elif [ ${CAPACITY} -lt 15 ]; then
        DISPLAY=:0.0 /usr/bin/notify-send -i battery-low -u normal "Battery warning!" "${BATTINFO}"
    fi
fi
