#!/bin/sh

PRIMARY=$(pactl list sinks short|head -n 1|awk '{print $1}')

pactl set-sink-volume ${PRIMARY} ${1}

# Get current channel volume as average
AVG=$(pactl list sinks | sed -n '/^Sink #'${PRIMARY}'/,/Volume:/p'|tail -n 1|awk -F"/" '{print ($2+$4)/2}')

for SINK in $(pactl list sinks short|awk '{print $1}'); do
  pactl set-sink-volume ${SINK} ${AVG}%
done

