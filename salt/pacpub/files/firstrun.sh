#!/bin/bash
# Filename:     firstrun.sh
# Purpose:      Setup local kiosk non-interactively on first run
#               e.g. firefox settings

# X environment, to access login greeter
export XAUTHORITY=/var/run/lightdm/root/:0 
export DISPLAY=:0

# login
xdotool key Return
sleep 10

# start firefox
pkill firefox # kill any open firefox
su bib -c "firefox {{ pillar['startpage'] }} &" # start firefox for bib user
sleep 10

# do firefox mods
WID=`xdotool search "Mozilla Firefox" 2> /dev/null | head -1`
if [ -n "$WID" ]
then
  xdotool windowactivate --sync $WID
  sleep 1
  KEYS=(
    # 'Alt+r i i Return'     # preferences
    # 'Alt+b'                # use current homepage
    # 'Alt+oslash'           # always ask me where to save files
    # 'Tab Tab'              # back to preferences tabs
    # 'Left Left Left Left'  # switch to privacy tab
    # 'Alt+f a'              # never remember history
    # 'Return'               # allow history setting to restart browser
    # 'Right Right'          # health report
    # 'Alt+s Alt+aring'      # disable health report
    'Alt+e n'                   # open preferences
    'Alt+c'                     # use current homepage
    'Alt+a'                     # always ask me where to save files
    'Tab Tab Tab'               # back to preferences tabs
    'Right Right Right Right'   # switch to privacy tab
    'Alt+w n'                   # never remember history

    'Escape'               # exit preferences
    'Ctrl+l'
    'a b o u t colon a d d o n s Return'
    'Tab Tab'
    'Home Down Down Down'
    'Tab Tab Down'
    'Tab Tab Down'
    'Ctrl+w'
    'Alt+F4'               # exit firefox cleanly
  )
  # loop over keystrokes with sleep interval
  for keys in "${KEYS[@]}"
  do
    sleep 1
    xdotool key --delay 20 $keys
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
       \"comment\":\"$COMMENT\"\
       \"}"
exit $EXITCODE
