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
sleep 8

# do firefox mods
WID=`xdotool search "Mozilla Firefox" | head -1`
if [ -n "$WID" ]
then
  xdotool windowactivate --sync $WID
  sleep 3
  xdotool key --delay 20 Alt+e n        # open preferences
  xdotool key Alt+c                     # use current homepage
  xdotool key Alt+a                     # always ask me where to save files
  xdotool key Tab Tab Tab               # back to preferences tabs
  xdotool key Right Right Right Right   # switch to privacy tab
  xdotool key Alt+w n                   # never remember history
  xdotool key Escape
  sleep 5
  pkill firefox
  CHANGED=true
  COMMENT='Firefox started and updated'
  EXITCODE=0
else
  CHANGED=false
  COMMENT='Error: firefox not started'
  EXITCODE=1
fi
# Return state
echo 
echo "{\"result\":\"$RESULT\",\
       \"changed\":\"$CHANGED\",\
       \"comment\":\"$COMMENT\"}"
exit $EXITCODE
