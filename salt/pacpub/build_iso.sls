########
# BUiLD REMASTERSYS ISO
########

/etc/remastersys.conf:
  file.managed:
    - source: salt://pacpub/files/remastersys.conf

apt-clean:
  cmd.run: 
  - name: apt-get -y autoremove && apt-get clean

historyclean:
  cmd.run:
    - name: history -c && rm -rf .mozilla/firefox/cache/*
    - user: bib

salt-minion:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://pacpub/files/minion
    - template: jinja
    - context:
      master: 192.168.0.1
      grandmaster: {{ pillar['grandmaster'] }}

minion-service:
  file.managed:
    - name: /etc/init/salt-minion
    - source: salt://pacpub/files/salt-minion.conf.tmpl

remastersys:
  cmd.run:
    - name: remastersys clean && remastersys backup

move_iso:
  cmd.run:
    - name: mv /home/remastersys/remastersys/mycelimage-backup.iso /vagrant/mycelimage-newest.iso
    - require:
      - cmd: remastersys