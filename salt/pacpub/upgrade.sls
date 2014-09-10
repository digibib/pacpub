##########
# UPGRADE PACKAGES
##########

include:
  - pacpub

upgradepkgs:
  pkg.latest:
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
      - openssh-server
      - lxlauncher
      - flashplugin-installer
      - oracle-java7-installer
    - skip_verify: True
