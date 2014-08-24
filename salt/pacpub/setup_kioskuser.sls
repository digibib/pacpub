########
# KIOSK AUTOSTART SETTINGS
########

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

/usr/local/bin/autostart_kiosk.sh:
  file.managed:
    - source: salt://pacpub/files/autostart_kiosk.sh
    - mode: 755

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

# /home/bib/.mozilla/firefox/0hj15qc9.default/prefs.js:
#   file.managed:
#     - source: salt://pacpub/files/firefox/prefs.js
#     - user: bib
#     - group: bib

# /home/bib/.mozilla/firefox/profiles.ini:
#   file.managed:
#     - source: salt://pacpub/files/firefox/profiles.ini
#     - user: bib
#     - group: bib


########
# KEYBINDINGS
########

/home/bib/.config/openbox/lubuntu-rc.xml:
  file.managed:
    - source: salt://pacpub/files/lxde/lubuntu-rc.xml
    - user: bib
    - group: bib

{% for folder in ['Bilder','Dokumenter','Maler','Musikk','Offentlig','Skrivebord','Videoklipp'] %}
/home/bib/{{folder}}:
  file.absent
{% endfor %}

/home/bib/USB:
  file.symlink:
    - target: /media

########
# FIRSTRUN
########

# lightdm uses .xprofile for login scripting
firstrun:
  cmd.script:
    - source: salt://pacpub/files/firstrun.sh
    - template: jinja
    - stateful: True
    - require:
      - file: /usr/local/bin/firefoxproxy.pac
