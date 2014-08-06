########
# KIOSK AUTOSTART SETTINGS
########


# login sync from kiosk
# /home/bib/.xsession:
#   file.managed:
#     - source: salt://pacpub/files/.xsession
#     - user: bib
#     - group: bib
    # - force: True
    # - template: jinja
    # - context:
    #   Startpage: {{ pillar['startpage'] }}

bibuser:
  user.present:
    - name: bib
    - fullname: Publikumsbruker
    - shell: /bin/bash
    - home: /home/bib
    - password: {{ pillar['adminpass'] }}
    - groups:
      - nopasswdlogin

# lightdm uses .xprofile for login scripting
/home/bib/.xprofile:
  file.managed:
    - source: salt://pacpub/files/.xprofile
    - user: bib
    - group: bib
    - force: True
    # - template: jinja
    # - context:
    #   Startpage: {{ pillar['startpage'] }}

/usr/local/bin/autostart_kiosk.sh:
  file.managed:
    - source: salt://pacpub/files/autostart_kiosk.sh
    - mode: 755

# Disabled in Saucy

# /home/bib/.config/autostart:
#   file.directory:
#     - makedirs: True
#     - user: bib
#     - group: bib

# /home/bib/.config/autostart/autostart_kiosk.desktop:
#   file.managed:
#     - source: salt://pacpub/files/lxde/autostart_kiosk.desktop
#     - user: bib
#     - group: bib

########
# APPLICATIONS
########

applications:
  file.directory:
    - name: /home/bib/.local/share/applications
    - makedirs: True
    - user: bib
    - group: bib

# hide java webstart
/home/bib/.local/share/applications:
  file.recurse:
    - source: salt://pacpub/files/lxde/applications
    - user: bib
    - group: bib
    - require:
      - file: applications

########
# MENUS
########

menus:
  file.directory:
    - name: /home/bib/.config/menus
    - makedirs: True
    - user: bib
    - group: bib

/home/bib/.config/menus:
  file.recurse:
    - source: salt://pacpub/files/lxde/menus
    - user: bib
    - group: bib
    - require:
      - file: menus

########
# DESKTOP-DIRECTORIES
########

desktop-directories:
  file.directory:
    - name: /home/bib/.local/share/desktop-directories
    - makedirs: True
    - user: bib
    - group: bib


/home/bib/.local/share/desktop-directories:
  file.recurse:
    - source: salt://pacpub/files/lxde/desktop-directories
    - user: bib
    - group: bib
    - clean: True
    - require:
      - file: desktop-directories

########
# ICONS
########

icons:
  file.directory:
    - name: /usr/local/src/icons
    - makedirs: True
    - user: bib
    - group: bib


/usr/local/src/icons:
  file.recurse:
    - source: salt://pacpub/files/lxde/icons
    - user: bib
    - group: bib
    - clean: True
    - require:
      - file: icons

########
# FIREFOX
########

/usr/local/bin/firefoxproxy.pac:
  file.managed:
    - source: salt://pacpub/files/firefox/firefoxproxy.pac

/home/bib/.mozilla/firefox/0hj15qc9.default/prefs.js:
  file.managed:
    - source: salt://pacpub/files/firefox/prefs.js
    - user: bib
    - group: bib

/home/bib/.mozilla/firefox/profiles.ini:
  file.managed:
    - source: salt://pacpub/files/firefox/profiles.ini
    - user: bib
    - group: bib

########
# KEYBINDINGS
########

/home/bib/.config/openbox/lubuntu-rc.xml:
  file.managed:
    - source: salt://pacpub/files/lxde/lubuntu-rc.xml
    - user: bib
    - group: bib

