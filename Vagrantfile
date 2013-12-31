# -*- mode: ruby -*-
# vi: set ft=ruby :
# --------------------------------------------------------------
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# --------------------------------------------------------------


# Vagrantfile API/syntax version. 
VAGRANTFILE_API_VERSION = "2"

# whether or not to install X Windows and eclipse
INSTALL_DESKTOP=true

# by default the Virtualbox guest UI is disabled
# can be enabled on with the vagrant up command: 
# $ VB_GUI=true vagrant up
VB_GUI=false

if ENV["VB_GUI"] == "true" then VB_GUI = true
else
   puts("[info] VB_GUI environment variable not set so running headless") 
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

#  config.proxy.http     = "http://192.168.1.79:3128/"
#  config.proxy.https    = "http://192.168.1.79:3128/"
#  config.proxy.no_proxy = "localhost,127.0.0.1"
  
  config.vm.box = "centos64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

  config.vm.network "private_network", ip: "192.168.55.10"

  config.vm.provider :virtualbox do |vb|
     vb.gui = VB_GUI
     vb.customize ["modifyvm", :id, "--memory", "5120"]
  end
 
  #####################
  # Maven synced folder
  #####################

  config.vm.synced_folder File.expand_path("~/.vagrant.d/.m2"),
	"/home/vagrant/.m2/", 
        :create => true,
	:mount_option => "dmode=777,fmode=666"

  ###############
  # PLUGIN CONFIG
  ###############

  # vbguest : https://github.com/dotless-de/vagrant-vbguest
  config.vbguest.auto_update = false

  # vagrant-cachier : https://github.com/fgrehm/vagrant-cachier
  config.cache.auto_detect = true

  ##############
  # PROVISIONING
  ##############
  
  config.vm.provision "shell", path: "scripts/create_folders.sh"
  config.vm.provision "shell", path: "scripts/openstack_setup.sh"
  config.vm.provision "shell", path: "scripts/maven_setup.sh"

  if INSTALL_DESKTOP
     config.vm.provision "shell", path: "scripts/desktop_setup.sh"
  end

  config.vm.provision "shell", path: "scripts/stratos_developer_setup.sh"
  config.vm.provision "shell", path: "scripts/stratos_runtime_setup.sh"
  config.vm.provision "shell", inline: "sudo reboot"

end
