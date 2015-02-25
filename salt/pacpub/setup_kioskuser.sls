########
# CLEAN SLATE
########

/opt/kiosk:
  file.absent

# mycel-client, ssh-agent and menu-cached must be killed before user is removed
{% for proc in ['mycel-client', 'ssh-agent', 'menu-cached'] %}
kill_{{proc}}:
  cmd.run:
    - name: pkill {{proc}} || true
{% endfor %}

purge_bibuser:
  user.absent:
    - name: bib
    - purge: True
    - force: True

bibuser:
  user.present:
    - name: bib
    - fullname: Publikumsbruker
    - shell: /bin/bash
    - home: /home/bib
    - password: {{ pillar['adminpass'] }}
    - groups:
      - nopasswdlogin
    - require:
      - user: purge_bibuser

########
# FIRSTRUN
########

firstrun:
  cmd.script:
    - source: salt://pacpub/files/firstrun.sh
    - template: jinja
    - stateful: True
    - require:
      - file: /home/vagrant/proxy.pac

########
# PROFILE
########

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
# DESKTOP APPLICATIONS
########

applications:
  file.directory:
    - name: /home/bib/.local/share/applications
    - makedirs: True
    - user: bib
    - group: bib

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

# disable system logout for kiosk user
/usr/bin/lxsession-logout:
  file.managed:
    - user: root
    - group: vagrant
    - mode: 754

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

/home/vagrant/proxy.pac:
  file.managed:
    - source: salt://pacpub/files/firefox/firefoxproxy.pac

/home/bib/.mozilla/firefox/0hj15qc9.default:
  file.directory:
    - user: bib
    - group: bib
    - makedirs: True

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
# KEYBINDINGS AND FOLDERS
########

/home/bib/.config/openbox/lubuntu-rc.xml:
  file.managed:
    - source: salt://pacpub/files/lxde/lubuntu-rc.xml
    - user: bib
    - group: bib

{% for folder in ['Bilder','Dokumenter','Maler','Musikk','Offentlig','Videoklipp'] %}
/home/bib/{{folder}}:
  file.absent
{% endfor %}

/home/bib/USB:
  file.symlink:
    - target: /media
    - user: bib
    - group: bib
