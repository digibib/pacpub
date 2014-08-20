#!/bin/bash
# Filename:     firstrun.sh
# Purpose:      Setup local kiosk non-interactively
#               e.g. firefox settings

export XAUTHORITY=/var/run/lightdm/root/:0 
export DISPLAY=:0 

# login
xdotool key Return
sleep 5

# start firefox
firefox {{ pillar['startpage'] }} &
sleep 5

# do firefox mods
WID=`xdotool search "Mozilla Firefox" | head -1`
if [ -n "$WID" ]
then
  xdotool windowactivate --sync $WID
  xdotool key --clearmodifiers ctrl+l

  sleep 1
  pkill firefox
  CHANGED=yes
  COMMENT='Firefox started and updated'
else
  echo "{\"ERROR\":\"firefox not started\"}"
  exit 1
fi
echo 
echo "{\"changed\":\"$CHANGED\", \"comment\":\"$COMMENT\"}"