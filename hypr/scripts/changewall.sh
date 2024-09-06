#!/bin/bash

DIR=$HOME/Pictures/wall/
PICS=($(ls ${DIR}))
while true
do
	
	RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}
	if [[ $(pidof swaybg) ]]; then
  		pkill swaybg
	fi

	swww query || swww init

	#change-wallpaper using swww
	swww img ${DIR}/${RANDOMPICS} --transition-fps 30 --transition-type any --transition-duration 3
#	wal -i  ${DIR}${RANDOMPICS} -n
	sleep 600 
done &
