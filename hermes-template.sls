docker.io:
    pkg.installed:
        - pkgs:
            - docker.io

systemctl disable docker:
  cmd.run:
    - runas: root
    - requires:
      - qvm: hermes-research-dvm
