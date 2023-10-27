/rw/config/qubes-bind-dirs.d/docker.conf:
  file.managed:
    - makedirs: True
    - mode: 0600
    - contents: |
        binds+=( '/var/lib/docker' )

bind-dirs-docker:
  cmd.run:
    - name: /usr/lib/qubes/init/bind-dirs.sh umount && /usr/lib/qubes/init/bind-dirs.sh
    - require:
        - file: /rw/config/qubes-bind-dirs.d/docker.conf

/home/user/hermesweb:
    file.recurse:
        - source: salt://hermesweb
        - makedirs: True
        - owner: user
        - group: user

docker-start:
  cmd.run:
    - runas: root
    - name: systemctl start docker
    - require:
        - cmd: bind-dirs-docker

docker-create-webserver:
  cmd.run:
    - runas: root
    - name: docker build -t hermesweb .
    - cwd: /home/user/hermesweb
    - require:
        - file: /home/user/hermesweb

/rw/config/rc.local:
  file.append:
    - text: |
        echo 127.0.0.1 hwresearch.somewhere.oni >> /etc/hosts
        systemctl start docker && docker run -d -p 8080:80 hermesweb
