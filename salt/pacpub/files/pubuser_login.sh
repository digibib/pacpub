#!/bin/bash
#/etc/lightdm/pubuser_login.sh

# empty public user and create session
LOG=/tmp/log
USER=`whoami`
if [ $USER = "bib" ]; then
  echo "Prelogin user 1: $USER" >> $LOG
  /usr/bin/rsync -av --delete /opt/kiosk /home/bib 
fi
