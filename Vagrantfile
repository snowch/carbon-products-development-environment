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

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "centos64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

  #config.vm.network "private_network", ip: "192.168.55.10"
  config.vm.network "forwarded_port", guest: 3389, host: 4480

  ###############
  # PLUGIN CONFIG
  ###############

  # These vm's download lots of packages, so caching can improve
  # performance when creating new machines.
  #
  # vagrant-cachier : https://github.com/fgrehm/vagrant-cachier
  config.cache.auto_detect = true

  # vbguest : https://github.com/dotless-de/vagrant-vbguest
  config.vbguest.auto_update = true

  ###########################################
  #
  # Openstack machine
  #
  ###########################################

  config.vm.define "openstack" do |openstack|

     openstack.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
     end
     openstack.vm.provision "shell", path: "scripts/openstack_setup.sh"

  end


  config.vm.define "stratosdev" do |stratosdev|

    # May need to set this if UI takes a long time booting
    #config.vm.boot_timeout = xx

     stratosdev.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
     end

     # Maven synced folder 

     stratosdev.vm.synced_folder File.expand_path("~/.vagrant.d/.m2"),
	"/home/vagrant/.m2/", 
        :create => true,
	:mount_option => "dmode=777,fmode=666"

     stratosdev.vm.provision "shell", path: "scripts/create_folders.sh"
     stratosdev.vm.provision "shell", path: "scripts/maven_setup.sh"
     stratosdev.vm.provision "shell", path: "scripts/desktop_setup.sh"
     stratosdev.vm.provision "shell", path: "scripts/stratos_developer_setup.sh"
     # TODO : restart?
  end

  config.vm.define "stratosruntime" do |stratosruntime|
 
     #config.vm.synced_folder "./stratos_installer",
#	"/home/vagrant/stratos/", 
#        :create => true,
#	:mount_option => "dmode=777,fmode=666"

     #stratosruntime.vm.provision "shell", path: "scripts/stratos_runtime_setup.sh"
  end

end
