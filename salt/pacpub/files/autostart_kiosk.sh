#!/usr/bin/env bash
#usr/local/bin/autostart_kiosk.sh - run as root
# restore kioskuser upon login
if [ -d "/opt/kiosk" ]
then
  rsync -qa --delete --exclude='.Xauthority' --exclude='.cache' /opt/kiosk/ $HOME/
fi