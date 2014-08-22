#!/bin/bash
# Filename:     firstrun.sh
# Purpose:      Setup local kiosk non-interactively on first run
#               e.g. firefox settings

# X environment, to access login greeter
export XAUTHORITY=/var/run/lightdm/root/:0 
export DISPLAY=:0 

# login
xdotool key Return
sleep 5

# start firefox
pkill firefox # kill any open firefox
LC_ALL=en_US firefox -no-remote {{ pillar['startpage'] }} & # start firefox in english for setup
sleep 10

# do firefox mods
WID=`xdotool search "Mozilla Firefox" | head -1`
if [ -n "$WID" ]
then
  xdotool windowactivate --sync $WID
  sleep 1
  KEYS=(
    'Alt+e n'              # preferences
    'Alt+c'                # use current homepage
    'Alt+a'                # always ask me where to save files
    'Tab Tab'              # back to preferences tabs
    'Left Left Left Left'  # switch to privacy tab
    'Alt+w n'              # never remember history
    'Return'               # allow history setting to restart browser
    'Escape'               # exit preferences
    'Alt+F4'               # exit firefox cleanly
  )
  # loop over keystrokes with sleep interval
  for keys in "${KEYS[@]}"
  do
    sleep 1
    xdotool key --delay 20 --clearmodifiers $keys
  done

  CHANGED=true
  COMMENT="Firefox started and updated\n$WID"
  EXITCODE=0
else
  CHANGED=false
  COMMENT="Error: not able to access firefox"
  EXITCODE=1
fi
# Return state
echo 
echo "{\"result\":\"$RESULT\",\
       \"changed\":\"$CHANGED\",\
       \"comment\":\"$COMMENT\"}"
exit $EXITCODE
