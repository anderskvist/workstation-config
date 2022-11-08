#!/bin/sh

FILE=/tmp/screen_locked.png

# Delete old file
rm -f ${FILE}

# Take a screenshot
scrot ${FILE}

# Pixellate it 10x
mogrify -scale 10% -scale 1000% ${FILE}

# Blank
blank.sh &

# Lock screen displaying this image.
i3lock -i ${FILE}
