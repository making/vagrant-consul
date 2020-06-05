#!/bin/bash

set -exuo pipefail

VAGRANT_PROVISION=/var/vagrant/provison
eval "$(cat /vagrant/share/*.sh)"

if [ ! -f ${VAGRANT_PROVISION}/resolved ];then
  sed -i \
      -e 's/^#DNSStubListener=yes/DNSStubListener=no/' \
      /etc/systemd/resolved.conf
  rm -f /etc/resolv.conf
  ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
  systemctl restart systemd-resolved
  touch ${VAGRANT_PROVISION}/resolved
fi