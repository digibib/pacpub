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
su bib -c "LANG=en-GB firefox {{ pillar['startpage'] }} &" # start firefox for bib user
sleep 10

# do firefox mods
WID=`xdotool search "Mozilla Firefox" 2> /dev/null | head -1`
if [ -n "$WID" ]
then
  xdotool windowactivate --sync $WID
  sleep 1
  
  # FIRST RUN - FIREFOX HOMEPAGE AND PRIVACY
  KEYS=(
    'Alt+e n'                   # open preferences
    'Alt+c'                     # use current homepage
    'Alt+a'                     # always ask me where to save files
    'Tab Tab Tab'               # back to preferences tabs
    'Left Left Left Left'       # switch to privacy tab
  )
  # loop over keystrokes with sleep interval
  for keys in "${KEYS[@]}"
  do
    sleep 1
    xdotool key --delay 20 $keys
  done
  sleep 3
  xdotool key  'Alt+w n'        # never remember history
  sleep 5
  # SECOND RUN - ADDONS
  KEYS=(
    'Alt+e n'
    'Right Right Right'
    'Tab Right'
    'Alt+r'                    # disable crash reporting
    'Alt+c'                    # disable crash reporting
    'Tab Tab Tab Tab Tab'
    'Right Tab Return'         # network settings
    'Alt+a Tab'                # automatic proxy
    'f i l e colon slash slash slash t m p slash p r o x y period p a c'
    'Tab Tab Tab Return'
    'Shift+Tab Shift+Tab Right' # Return to start
    'Escape'                    # exit preferences
    'Ctrl+l'
    'a b o u t colon a d d o n s Return'
    'Tab Tab'
    'Home Down Down Down'
    'Tab Tab Down'
    'Tab Tab Down'
    'Alt+w'
    'Alt+F4'               # exit firefox cleanly
  )
  # loop over keystrokes with sleep interval
  for keys in "${KEYS[@]}"
  do
    sleep 1
    xdotool key --delay 20 $keys
  done

  CHANGED=true
  COMMENT="Firefox started and updated"
  EXITCODE=0
else
  CHANGED=false
  COMMENT="Error: not able to access firefox"
  EXITCODE=1
fi
# Return state
echo 
echo "{\"changed\":\"$CHANGED\",\
       \"comment\":\"$COMMENT\"\
      }"
exit $EXITCODE
