# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"

  (1..1).each do |n| 
    config.vm.define "consul-server-#{n}" do |c|
      c.vm.hostname = "consul-server-#{n}.internal"
      c.vm.network "private_network", ip: "10.240.0.1#{n}"
      c.vm.network "public_network", ip: "192.168.11.21#{n}", bridge: "en0: Wi-Fi (Wireless)"
      c.vm.provider "virtualbox" do |v|
        v.gui = false
        v.cpus = 1
        v.memory = 512
      end
  
      c.vm.provision :shell, :path => "scripts/setup-initial-ubuntu.sh"
      c.vm.provision :shell, :path => "scripts/setup-dns.sh"
      c.vm.provision :shell, :path => "scripts/setup-consul.sh"
      c.vm.provision :shell, :path => "scripts/setup-consul-server.sh"
    end
  end

  (1..2).each do |n|
    config.vm.define "consul-client-#{n}" do |c| 
      c.vm.hostname = "consul-client-#{n}.internal"
      c.vm.network "private_network", ip: "10.240.0.2#{n}"
      c.vm.network "public_network", ip: "192.168.11.22#{n}", bridge: "en0: Wi-Fi (Wireless)"
      c.vm.provider "virtualbox" do |v|
        v.gui = false
        v.cpus = 1
        v.memory = 512
      end

      c.vm.provision :shell, :path => "scripts/setup-initial-ubuntu.sh"
      c.vm.provision :shell, :path => "scripts/setup-consul.sh"
      c.vm.provision :shell, :path => "scripts/setup-consul-client.sh"
      c.vm.provision :shell, :path => "scripts/setup-rsyslog.sh"
    end
  end
  
end
