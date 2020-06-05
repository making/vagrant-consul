#!/bin/bash

set -exuo pipefail

VAGRANT_PROVISION=/var/vagrant/provison
NODE_IP=$(ip a show enp0s9 | grep inet | grep -v inet6 | awk '{print $2}' | cut -f1 -d/)

cat <<EOF >  /vagrant/share/$(hostname).sh
export $(hostname | tr '-' '_' | tr '[a-z]' '[A-Z]')_IP=${NODE_IP}
EOF
eval "$(cat /vagrant/share/*.sh)"

if [ ! -f ${VAGRANT_PROVISION}/consul ];then
  echo "Determining Consul version to install ..."
  CHECKPOINT_URL="https://checkpoint-api.hashicorp.com/v1/check"
  CONSUL_VERSION=$(curl -s "${CHECKPOINT_URL}"/consul | jq .current_version | tr -d '"')
  
  echo "Fetching Consul version ${CONSUL_VERSION} ..."
  cd /tmp/
  curl -s https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o consul.zip
  
  echo "Installing Consul version ${CONSUL_VERSION} ..."
  unzip consul.zip
  sudo chmod +x consul
  sudo mv consul /usr/bin/consul
  
  sudo mkdir /etc/consul.d
  sudo chmod a+w /etc/consul.d
  rm -f consul.zip
  touch ${VAGRANT_PROVISION}/consul
fi


if [ ! -f ${VAGRANT_PROVISION}/consul-user ];then
  sudo useradd --system --home /etc/consul.d --shell /bin/false consul
  sudo mkdir --parents /opt/consul
  sudo chown --recursive consul:consul /opt/consul
  sudo chown --recursive consul:consul /etc/consul.d
  touch ${VAGRANT_PROVISION}/consul-user
fi

sudo cp /vagrant/consul.service /etc/systemd/system/

cat <<EOF > /etc/consul.d/consul.hcl
datacenter = "vagrant"
data_dir = "/opt/consul"
encrypt = "Luj2FZWwlt8475wD1WtwUQ=="
client_addr = "0.0.0.0"
bind_addr = "${NODE_IP}"
EOF