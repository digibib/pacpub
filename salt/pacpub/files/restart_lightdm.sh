#!/bin/bash
#/etc/lightdm/restart_lightdm.sh

trap "" SIGHUP SIGINT SIGTERM
PATH=$PATH:/sbin:/usr/sbin
service lightdm restart 
