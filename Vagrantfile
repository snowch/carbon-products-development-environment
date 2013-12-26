# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. 
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
set -e
set -x

sudo yum install -y http://rdo.fedorapeople.org/rdo-release.rpm
sudo yum install -y openstack-packstack expect
SCRIPT

$script2 = <<SCRIPT
expect << EOF
set timeout -1
spawn "/usr/bin/packstack" "--allinone"
expect "Setting up ssh keys...root@10.0.2.15's password:"
send "vagrant\n"
expect eof
EOF
SCRIPT


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "centos64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

#  config.vm.network "public_network"
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--memory", "5120"]
  end

  config.vm.provision "shell", inline: $script
  config.vm.provision "shell", inline: $script2
end
