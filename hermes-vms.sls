{% set gui_user = salt['cmd.shell']('groupmems -l -g qubes') %}

# qubes-template-debian-12-xfce:
#   pkg.installed: []

sys-tor:
  qvm.present:
    - template: debian-12-xfce
    - label: gray
    - mem: 600
    - vcpus: 2
    - netvm: sys-firewall
    - flags:
      - proxy

hermes-research-dvm:
  qvm.vm:
    - present:
        - label: red
    - prefs:
        - label: red
        - template: debian-12-xfce
        - dispvm-allowed: True
        - netvm: sys-tor
    - features:
        - enable:
            - appmenus-dispvm

qvm-appmenus --get-default-whitelist debian-12-xfce | grep -i 'firefox\|term' | qvm-appmenus --set-whitelist=- --update hermes-research-dvm:
  cmd.run:
    - runas: {{gui_user}}
    - requires:
      - qvm: hermes-research-dvm

vpn-pltf:
  qvm.present:
    - template: debian-12-xfce
    - label: gray
    - mem: 600
    - vcpus: 2
    - flags:
      - proxy
    - netvm: sys-firewall


vpn-hq:
  qvm.present:
    - template: debian-12-xfce
    - label: gray
    - mem: 600
    - vcpus: 2
    - flags:
      - proxy
    - netvm: sys-firewall

hermes-webui:
  qvm.present:
    - template: debian-12-xfce
    - label: green
    - mem: 2000
    - vcpus: 2
    - netvm: vpn-pltf

hermes-exchange:
  qvm.present:
    - template: debian-12-xfce
    - label: green
    - mem: 2000
    - vcpus: 2
    - netvm: vpn-pltf

hermes-exchange-usb:
  qvm.present:
    - template: debian-12-xfce
    - label: green
    - mem: 2000
    - vcpus: 2
    - netvm: none

hermes-notification:
  qvm.present:
    - template: debian-12-xfce
    - label: orange
    - mem: 2000
    - vcpus: 2
    - netvm: vpn-hq
