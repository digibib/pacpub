#!/bin/bash
# Filename:     autostart_kiosk.sh
# When:         runs as root on each lightdm start/restart
# Purpose:      Setup user from skeleton, Live system mods

# RESTORE KIOSKUSER UPON LOGIN
if [ -d "/opt/kiosk" ]
then
  rsync -qa --delete --exclude='.Xauthority' --exclude='.cache' /opt/kiosk/ $HOME/
fi