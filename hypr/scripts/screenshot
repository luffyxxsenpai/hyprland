#!/usr/bin/env bash

# Flags:

# r: region
# s: screen
#
# c: clipboard
# f: file
# i: interactive

# p: pixel

if [[ $1 == rc ]]; then
    grim -g "$(slurp -b '#000000b0' -c '#00000000')" - | wl-copy
    notify-send 'Copied to Clipboard' screenshot

elif [[ $1 == rf ]]; then
    mkdir -p ~/Pictures/screenshots
    filename=~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
    grim -g "$(slurp -b '#000000b0' -c '#00000000')" $filename
    notify-send 'Screenshot Taken' $filename

elif [[ $1 == ri ]]; then
    grim -g "$(slurp -b '#000000b0' -c '#00000000')" - | swappy -f -

elif [[ $1 == sc ]]; then
    filename=~/Pictures/screenshots/%Y-%m-%d_%H-%M-%S.png
    grim - | wl-copy
    notify-send 'Copied to Clipboard' screenshot

elif [[ $1 == sf ]]; then
    mkdir -p ~/Pictures/screenshots
    filename=~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
    grim $filename
    notify-send 'screenshot Taken' $filename

elif [[ $1 == si ]]; then
    grim - | swappy -f -

elif [[ $1 == p ]]; then
    color=$(hyprpicker -a)
    wl-copy $color
    notify-send 'Copied to Clipboard' $color
fi
