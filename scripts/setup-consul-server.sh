#!/bin/bash

set -exuo pipefail

VAGRANT_PROVISION=/var/vagrant/provison
eval "$(cat /vagrant/share/*.sh)"

cat <<EOF > /etc/consul.d/server.hcl
server = true
bootstrap_expect = 1
ui = true
ports = {
  dns = 53
}
recursors = ["8.8.8.8"]
EOF

sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/*.hcl
sudo setcap 'cap_net_bind_service=+ep' /usr/bin/consul

if [ ! -f ${VAGRANT_PROVISION}/consul-server ];then
  echo "Consul Server Setup"
  sudo systemctl daemon-reload
  sudo systemctl enable consul
  sudo systemctl start consul
  touch ${VAGRANT_PROVISION}/consul-server
fi