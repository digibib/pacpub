########
# SAVE KIOSKUSER STATE
########

save_kiosk:
  cmd.run:
    - name: rsync -avp --delete --exclude='.cache' --exclude='.Xauthority' /home/bib/ /opt/kiosk/

# setup autologin bib user and logon/logoff scripts
/etc/lightdm/lightdm.conf:
  file.managed:
    - source: salt://pacpub/files/lightdm.conf
    - force: True

/etc/lightdm/restart_lightdm.sh:
  file.managed:
    - source: salt://pacpub/files/restart_lightdm.sh
    - mode: 755
    - force: True

##########
# SERVICES
##########

lightdm:
  service:
    - running
    - watch:
      - file: /etc/lightdm/lightdm.conf
    - stateful: True
