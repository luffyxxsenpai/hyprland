#!/bin/sh
## this script is to kill and reload waybar

killall waybar

if [[ $USER = "luffy"  ]]
then 
	waybar -c /home/luffy/.config/hypr/waybar/config  -s /home/luffy/.config/hypr/waybar/style.css

else
	waybar &
fi
