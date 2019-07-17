#!/bin/sh

# This works for a ThinkPad X1 Carbon 5th generation
# Requires pcspkr module is loaded and beep command installed

MASTERMUTE=$(amixer cget numid=11|grep "  : values"|cut -d"=" -f2)
MASTERVOLUME=$(amixer cget numid=10|grep "  : values"|cut -d"=" -f2)
PCMVOLUME=$(amixer cget numid=55|grep "  : values"|cut -d"=" -f2)
SPEAKERMUTE=$(amixer cget numid=4|grep "  : values"|cut -d"=" -f2)
SPEAKERVOLUME=$(amixer cget numid=3|grep "  : values"|cut -d"=" -f2)

amixer cset numid=11 on
amixer cset numid=10 100
amixer cset numid=55 0
amixer cset numid=4 on
amixer cset numid=3 100

# ascii values for "l o w b a t"
for I in 108 111 119 98 97 116; do
	beep -f $((${I}*10)) -l 50
done

amixer cset numid=11 ${MASTERMUTE}
amixer cset numid=10 ${MASTERVOLUME}
amixer cset numid=55 ${PCMVOLUME}
amixer cset numid=4 ${SPEAKERMUTE}
amixer cset numid=3 ${SPEAKERVOLUME}
