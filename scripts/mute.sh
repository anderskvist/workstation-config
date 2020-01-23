#!/bin/sh

pactl set-sink-mute 0 toggle

MUTE=$(pactl list sinks | sed -n '/^Sink #0/,/Mute:/p'|tail -n 1|awk '{print $2}')

for SINK in $(pactl list sinks short|awk '{print $1}'); do
  pactl set-sink-mute ${SINK} ${MUTE}
done


