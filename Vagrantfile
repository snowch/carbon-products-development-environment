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

  ###############
  # PLUGIN CONFIG
  ###############

  # These vm's download lots of packages, so caching can improve
  # performance when creating new machines.
  #
  # vagrant-cachier : https://github.com/fgrehm/vagrant-cachier

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  else
    # only display the tips on vagrant up
    if ARGV[0] == "up"
      puts "[information] recommended vagrant plugin 'vagrant-cachier' plugin was not found" 
      puts "[information] 'vagrant-cachier' will speed up repeated provisioning operations" 
    end
  end

  # Use the vbguest plugin to keep the guest os virtualbox utils
  # in line with the host's virtualbox version
  #
  # vbguest : https://github.com/dotless-de/vagrant-vbguest

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
  else 
    # only display the tips on vagrant up
    if ARGV[0] == "up"
      puts "[information] recommended vagrant plugin 'vagrant-vbguest' plugin was not found" 
      puts "[information] please consider installing 'vagrant-vbguest'" 
    end
  end

  ###########################################
  #
  # Openstack machine
  #
  ###########################################

  config.vm.define "openstack" do |openstack|
 
     openstack.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "4096"]
     end
     openstack.vm.provision "shell", path: "scripts/openstack_setup.sh"

  end

  ###########################################
  #
  # Stratos Development machine
  #
  ###########################################

  config.vm.define "stratosdev" do |stratosdev|

     # TODO get install_runtime parameter as environment variable
     install_runtime = true

     # May need to set this if UI takes a long time booting
     #config.vm.boot_timeout = xx

     # The host machine can use Remote Desktop Connection (windows) or
     # rdesktop (linux/osx) to connect to localhost:4480 the username
     # and password is vagrant/vagrant

     stratosdev.vm.network "forwarded_port", guest: 3389, host: 4480

     stratosdev.vm.provider :virtualbox do |vb|
        if install_runtime
           # need more memory if installing runtime
           vb.customize ["modifyvm", :id, "--memory", "4096"]
        else
           vb.customize ["modifyvm", :id, "--memory", "2048"]
        end
        vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
     end

     # Maven synced folder 
     #
     # TODO use a bigger base box so the m2 repository could be installed
     # on a local guest drive which will be much faster.  Currently, the
     # base box only has about 10Gb space

     stratosdev.vm.synced_folder File.expand_path("~/.vagrant.d/.m2"),
	"/home/vagrant/.m2/", 
        :create => true,
	:mount_option => "dmode=777,fmode=666"

     stratosdev.vm.provision "shell", path: "scripts/create_folders.sh"
     stratosdev.vm.provision "shell", path: "scripts/maven_setup.sh"
     stratosdev.vm.provision "shell", path: "scripts/desktop_setup.sh"
     stratosdev.vm.provision "shell", path: "scripts/stratos_developer_setup.sh"
     # TODO : restart?


     if install_runtime
        stratosdev.vm.provision "shell", path: "scripts/stratos_runtime_setup.sh"
        stratosdev.vm.provision "shell", path: "scripts/stratos_mb_setup.sh"
        stratosdev.vm.provision "shell", path: "scripts/stratos_cep_setup.sh"
        stratosdev.vm.provision "shell", 
           inline: "chown -R vagrant:vagrant /home/vagrant/stratos"
     end
  end

  ###########################################
  #
  # Stratos Runtime machine
  #
  ###########################################

  config.vm.define "stratosruntime" do |stratosruntime|

     stratosruntime.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
     end

     # the runtime deploys artifacts from the m2 repository
 
     stratosruntime.vm.synced_folder File.expand_path("~/.vagrant.d/.m2"),
	"/home/vagrant/.m2/", 
        :create => true,
	:mount_option => "dmode=777,fmode=666"

     stratosruntime.vm.provision "shell", 
        path: "scripts/stratos_runtime_setup.sh",
        args: ENV['FORCE_PROVISION'] == "true" ? "-f" : ""

     stratosruntime.vm.provision "shell", path: "scripts/stratos_mb_setup.sh"
     stratosruntime.vm.provision "shell", path: "scripts/stratos_cep_setup.sh"

     stratosruntime.vm.provision "shell", 
        inline: "chown -R vagrant:vagrant /home/vagrant/stratos"
  end

end
