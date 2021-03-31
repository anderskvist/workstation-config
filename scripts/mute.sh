#!/bin/sh

PRIMARY=$(pactl list sinks short|head -n1|awk '{print $1}')

pactl set-sink-mute ${PRIMARY} toggle

MUTE=$(pactl list sinks | sed -n '/^Sink #'${PRIMARY}'/,/Mute:/p'|tail -n 1|awk '{print $2}')

for SINK in $(pactl list sinks short|awk '{print $1}'); do
  pactl set-sink-mute ${SINK} ${MUTE}
  notify-send "Sound muted: ${MUTE}"
done


