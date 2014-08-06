#!/usr/bin/env bash
# restore kioskuser upon login
rsync -qa --delete --exclude='.Xauthority' --exclude='.cache' /opt/kiosk/ $HOME/