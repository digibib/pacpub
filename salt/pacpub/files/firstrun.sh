#!/bin/bash
# Filename:     firstrun.sh
# When:         run on first login for kiosk user, prepare user account before iso generation
# Purpose:      Setup local kiosk non-interactively on first run
#               e.g. firefox settings

# X environment, to access login greeter
export XAUTHORITY=/var/run/lightdm/root/:0 
export DISPLAY=:0

# login
xdotool key Return

# start firefox
pkill firefox # kill any open firefox
su bib -c "LANG=en-GB firefox {{ pillar['startpage'] }} &" # start firefox for bib user
sleep 5

pkill firefox
exit 0
