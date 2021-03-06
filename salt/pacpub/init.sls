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

autoaccept_msttffonts:
  cmd.run:
    - name: echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

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
      - firefox-locale-nb
      - language-pack-gnome-nb
      - language-pack-gnome-nb-base
      - libreoffice-writer
      - libreoffice-calc
      - libreoffice-impress
      - libreoffice-l10n-nb
      - myspell-nb
      - eog
      - evince
      - scrot
      - nfs-common
      - firefox
      - libav-tools
      - salt-minion
      - lxlauncher
      - xdotool
      - openssh-server
      - lubuntu-restricted-extras
      - ttf-mscorefonts-installer
      - pavucontrol
      - intel-microcode
      - chromium-browser
      - adobe-flashplugin
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
      - libreoffice-math
      - language-pack-en
      - gnumeric
      - xfburn
      - mtpaint
      - simple-scan
      - apparmor
      - xpad
      - guvcview
      - vino
      - light-locker

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
    - cwd:  /tmp
    - name: dpkg -i remastersys_3.0.4-2_all.deb
    - unless: dpkg -s remastersys_3.0.4-2_all.deb
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

# Timezone
/etc/timezone:
  file.managed:
    - source: salt://pacpub/files/timezone
    - force: True

# APT sources
/etc/apt/sources.list:
  file.managed:
    - source: salt://pacpub/files/sources.list


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
    - name: >
        lpadmin -E -p publikumsskriver -v socket://10.172.2.31:9100
        -o pdftops-renderer-default=pdftops
        -m openprinting-ppds:0/ppd/openprinting/Lexmark/Lexmark_MS810_Series.ppd
        -L "publikumsskriver" -E
#        -m foomatic-db-compressed-ppds:0/ppd/foomatic-ppd/HP-LaserJet_4050-Postscript.ppd
#    - name: lpadmin -E -p publikumsskriver -v socket://10.172.2.31:9100 -m gutenprint.5.2://hp-lj_4000/expert -L "publikumsskriver" -E

# make sure default printer is accepting jobs
enable_printer: 
  cmd.run:
    - name: accept publikumsskriver
    - require:
      - file: /etc/sudoers.d/sudo_lpadmin
      - cmd: setup_printer

# make publikumsskriver printer default
default_printer:
  cmd.run:
    - name: lpadmin -d publikumsskriver
    - require:
      - file: /etc/sudoers.d/sudo_lpadmin
      - cmd: setup_printer

##########
# ALSA DEFAULT SOUND CARD
##########

# this file will be updated from autostart.sh script on live image
/etc/asound.conf.tmpl:
  file.managed:
    - source: salt://pacpub/files/asound.conf.tmpl

/etc/pulse/default.pa:
  file.append:
    - text: set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo

##########
# LOCALES
##########

/etc/default/locale:
  file.managed:
    - source: salt://pacpub/files/locale

/etc/default/keyboard:
  file.managed:
    - source: salt://pacpub/files/keyboard

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

networking:
  service:
    - running
    - watch:
      - file: /etc/network/interfaces
    - stateful: True

##########
# CRON
##########

/etc/cron.d/pacpub:
  file.managed:
    - source: salt://pacpub/files/pacpub.cron
    - mode: 755

