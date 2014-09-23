########
# BUiLD ISO
########

/etc/remastersys.conf:
  file.managed:
    - source: salt://pacpub/files/remastersys.conf

apt-clean:
  cmd.run: 
  - name: apt-get -y autoremove && apt-get clean

historyclean:
  cmd.run:
    - name: history -c && rm -rf ~/.mozilla/firefox/cache/*
    - user: bib

########
# SETUP SALT MINION AND MASTERS
########

/etc/salt/minion_id:
  file.absent

salt-minion:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://pacpub/files/minion
    - template: jinja
    - context:
      grandmaster: {{ pillar['grandmaster'] }}

minion-service:
  file.managed:
    - name: /etc/init/salt-minion.conf
    - source: salt://pacpub/files/salt-minion.conf.tmpl

########
# BUiLD REMASTERSYS ISO
########

remastersys:
  cmd.run:
    - name: remastersys clean && remastersys backup

move_iso:
  cmd.run:
    - name: mv /home/remastersys/remastersys/mycelimage-backup.iso /vagrant/mycelimage-newest.iso
    - require:
      - cmd: remastersys