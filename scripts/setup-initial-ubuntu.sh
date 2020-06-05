#!/bin/bash

set -exuo pipefail

VAGRANT_PROVISION=/var/vagrant/provison


if [ ! -d ${VAGRANT_PROVISION} ];then
  echo "==== Create ${VAGRANT_PROVISION} ===="
  # set timezone
  sudo timedatectl set-timezone Asia/Tokyo
  
  # update all
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get install -y unzip curl jq dnsutils
  mkdir -p ${VAGRANT_PROVISION}
fi