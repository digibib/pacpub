########
# SAVE KIOSKUSER STATE
########

save_kiosk:
  cmd.run:
    - name: rsync -avp --delete --exclude='.cache' --exclude='.Xauthority' /home/bib/ /opt/kiosk/
