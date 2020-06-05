#!/bin/bash

set -exuo pipefail

VAGRANT_PROVISION=/var/vagrant/provison
eval "$(cat /vagrant/share/*.sh)"

cat <<EOF > /etc/consul.d/syslog.json
{
  "service": {
    "name": "syslog",
    "tags": [
      "rsyslog"
    ],
    "port": 514,
    "check": {
      "args": [
        "nc",
        "-z",
        "localhost",
        "514"
      ],
      "interval": "3s"
    }
  }
}
EOF
consul reload

sed -i \
    -e 's/^#module(load="imtcp")/module(load="imtcp")/' \
    -e 's/^#input(type="imtcp" port="514")/input(type="imtcp" port="514")/' \
    /etc/rsyslog.conf
systemctl restart rsyslog