#!/usr/bin/env bash
#usr/local/bin/autostart_kiosk.sh - run as root
# force run dhclient to update network + hostname from dhcp and dns
#dhclient eth0
# restore kioskuser upon login
rsync -qa --delete --exclude='.Xauthority' --exclude='.cache' /opt/kiosk/ $HOME/