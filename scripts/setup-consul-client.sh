#!/bin/bash

set -exuo pipefail

VAGRANT_PROVISION=/var/vagrant/provison
eval "$(cat /vagrant/share/*.sh)"

cat <<EOF > /etc/consul.d/client.hcl
retry_join = ["${CONSUL_SERVER_1_IP}"]
enable_local_script_checks = true
EOF

sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/*.hcl

if [ ! -f ${VAGRANT_PROVISION}/consul-client ];then
  echo "Consul Client Setup"
  sudo systemctl daemon-reload
  sudo systemctl enable consul
  sudo systemctl start consul
  touch ${VAGRANT_PROVISION}/consul-client
fi