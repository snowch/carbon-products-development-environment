# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. 
VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "centos64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

  config.vm.provider :virtualbox do |vb|
     vb.gui = true
     vb.customize ["modifyvm", :id, "--memory", "5120"]
  end

  config.vm.provision "shell", path: "openstack_setup.sh"
  config.vm.provision "shell", path: "desktop_setup.sh"
  config.vm.provision "shell", path: "stratos_developer_setup.sh"
end
