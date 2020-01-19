#!/bin/sh

pactl set-sink-volume 0 ${1}

# Get current channel volume as average
AVG=$(pactl list sinks | sed -n '/^Sink #0/,/Volume:/p'|tail -n 1|awk -F"/" '{print ($2+$4)/2}')

pactl set-sink-volume 0 ${AVG}%
pactl set-sink-volume 15 ${AVG}%


