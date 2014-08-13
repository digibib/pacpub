##########
# Mycelclient
# BASED ON LUBUNTU 1404 32b
##########

##########
# JAVA
##########

java:
  pkgrepo.managed:
    - ppa: webupd8team/java
    - keyserver: hkp://keyserver.ubuntu.com:80
    - keyid: 28B04E4A
    - require_in: installpkgs

autoaccept_oracle:
  cmd.run:
    - name: echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

oracle-java7-installer:
  pkg.installed:
    - require:
      - pkgrepo: java
      - cmd: autoaccept_oracle

##########
# PACKAGES
##########


installpkgs:
  pkg.installed:
    - pkgs:
      - python-software-properties
      - software-properties-common
      - system-config-printer-gnome
      - virtualbox-guest-x11  # modules needed for X to function in Virtualbox
      - language-pack-nb
      - libreoffice-writer
      - libreoffice-calc
      - libreoffice-l10n-nb
      - myspell-nb
      - eog
      - evince
      - scrot
      - nfs-common
      - firefox
      - vino
      - libav-tools
      - salt-minion
      - openssh-server
      - lxlauncher
      - flashplugin-installer
    - skip_verify: True

removepkgs:
  pkg.purged:
    - pkgs:
      - ace-of-penguins 
      - osmo 
      - gpicview
      - abiword
      - sylpheed
      - apport
      - pidgin
      - transmission
      - transmission-common
      - transmission-gtk
      - libreoffice-draw
      - libreoffice-impress
      - gnumeric
      - xfburn
      - mtpaint
      - simple-scan
      - apparmor
      - xpad
      - guvcview

remastersys_dependencies:
  pkg.installed:
    - pkgs:
      - cifs-utils
      - dialog
      - genisoimage
      - squashfs-tools
      - casper
      - libdebian-installer4
      - ubiquity-frontend-debconf
      - user-setup
      - discover
      - syslinux
      - xresprobe

/tmp/remastersys_3.0.4-2_all.deb:
  file.managed:
    - source: salt://pacpub/files/remastersys_3.0.4-2_all.deb

remastersys: 
  cmd.run:
    - name: dpkg -i /tmp/remastersys_3.0.4-2_all.deb
    - unless: dpkg -s /tmp/remastersys_3.0.4-2_all.deb
    - require:
      - file: /tmp/remastersys_3.0.4-2_all.deb
      - pkg: remastersys_dependencies

/etc/remastersys.conf:
  file.managed:
    - source: salt://pacpub/files/remastersys.conf
    - require:
      - cmd: remastersys

##########
# GLOBAL SETTINGS
##########

/etc/network/interfaces:
  file.managed:
    - source: salt://pacpub/files/network-interfaces

# dhclient hook to update hostname from dhcp
/etc/dhcp/dhclient-exit-hooks.d/hostname:
  file.managed:
    - source: salt://pacpub/files/dhclient-hostname
    - force: True

/etc/lightdm/lightdm.conf:
  file.managed:
    - source: salt://pacpub/files/lightdm.conf
    - force: True

# /etc/lightdm/pubuser_login.sh:
#   file.managed:
#     - source: salt://pacpub/files/pubuser_login.sh
#     - mode: 755
#     - force: True

/etc/lightdm/restart_lightdm.sh:
  file.managed:
    - source: salt://pacpub/files/restart_lightdm.sh
    - mode: 755
    - force: True

/usr/local/bin/autostart_kiosk.sh:
  file.managed:
    - source: salt://pacpub/files/autostart_kiosk.sh
    - mode: 755

########
# CHROMIUM
########

# /etc/chromium-browser/policies/managed/chomiumpolicies.json:
#   file.managed:
#     - source: salt://pacpub/files/chomiumpolicies.json

##########
# PRINTER
##########

# allow printer access
/etc/sudoers.d/sudo_lpadmin:
  file.managed:
    - source: salt://pacpub/files/sudo_lpadmin
    - mode: '0440'

setup_printer:
  cmd.run:
#    - name: lpadmin -E -p skranken -v socket://10.172.2.31:9100 -m gutenprint.5.2://hp-lj_4000/expert -L "Skranken" -E
    - name: lpadmin -E -p skranken -v socket://10.172.2.31:9100 -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/HP-LaserJet_4050-Postscript.ppd -L "Skranken" -E


# make sure default printer is accepting jobs
enable_printer: 
  cmd.run:
    - name: accept skranken
    - require:
      - file: /etc/sudoers.d/sudo_lpadmin
      - cmd: setup_printer

##########
# SHUTDOWN
##########

# allow user to shutdown
/etc/sudoers.d/sudo_shutdown:
  file.managed:
    - source: salt://pacpub/files/sudo_shutdown
    - mode: '0440'

########
# USERS
########

kataloguser:
  user.present:
    - name: katalog
    - fullname: Katalog
    - shell: /bin/bash
    - home: /home/katalog
    - password: {{ pillar['adminpass'] }}
    - groups:
      - dialout
      - adm
      - users
      - plugdev
      - sudo
      - lpadmin

##########
# MYCEL
##########

/usr/local/bin/mycel-client:
  file.managed:
    - source: salt://pacpub/files/mycel-client
    - mode: 755

##########
# SERVICES
##########


lightdm:
  service:
    - running
    - watch:
      - file: /etc/lightdm/lightdm.conf
    - stateful: True

networking:
  service:
    - running
    - watch:
      - file: /etc/network/interfaces
    - stateful: True
