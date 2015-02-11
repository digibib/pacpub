#!/bin/bash
# Filename:     autostart_kiosk.sh
# When:         runs as root on each lightdm start/restart
# Purpose:      Setup user from skeleton, Live system mods

# RESTORE KIOSKUSER UPON LOGIN
if [ -d "/opt/kiosk" ]
then
  rsync -qa --delete --exclude='.Xauthority' --exclude='.cache' /opt/kiosk/ $HOME/
fi

# SET DEFAULT ALSA SOUND CARD
APLAY=`aplay -L | grep -A 1 plughw | grep Analog -B 1 | grep -v Analog`
CARD=`echo $APLAY | cut -d: -f2- | cut -d, -f1 | cut -d= -f2`
DEVICE=`echo $APLAY | cut -d: -f2- | cut -d, -f2 | cut -d= -f2`

cat /etc/asound.conf.tmpl | sed -e "s/__CARD__/$CARD/g" | sed -e "s/__DEVICE__/$DEVICE/g" > /etc/asound.conf