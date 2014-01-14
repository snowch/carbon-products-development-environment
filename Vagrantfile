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

  unless Vagrant.has_plugin?("vagrant-triggers")
     abort "[Error] vagrant-triggers plugin not found - please install it"
  end

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
  # Stratos Development machine
  #
  ###########################################

  config.vm.define "stratosdev" do |stratosdev|

     # The host machine can use Remote Desktop Connection (windows) or
     # rdesktop (linux/osx) to connect to localhost:4480 the username
     # and password is vagrant/vagrant

     stratosdev.vm.network "forwarded_port", guest: 3389, host: 4480

     stratosdev.vm.provider :virtualbox do |vb|

        vb.customize ["modifyvm", :id, "--memory", "6144"]
        vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]

        # FIXME: Find/Create a base box with a larger drive
        # The CentOS image has insufficient space, so lets add
        # another drive until we create a new box. 

        file_to_disk = File.realpath( "." ).to_s + "/disk.vdi"

        if ARGV[0] == "up" && ! File.exist?(file_to_disk) 
           puts "Creating 5GB disk #{file_to_disk}."
           vb.customize [
                'createhd', 
                '--filename', file_to_disk, 
                '--format', 'VDI', 
                '--size', 5000 * 1024 # 5 GB
                ] 
           vb.customize [
                'storageattach', :id, 
                '--storagectl', 'SATA Controller', 
                '--port', 1, '--device', 0, 
                '--type', 'hdd', '--medium', 
                file_to_disk
                ]
        end
     end

     # Maven synced folder - speeds up repeated builds because
     # the m2 repo acts as a cache

     stratosdev.vm.synced_folder File.expand_path("~/.vagrant.d/.m2"),
	"/home/vagrant/.m2/", 
        :create => true,
	:mount_option => "dmode=777,fmode=666"

     stratosdev.vm.provision "shell", path: "scripts/add_new_disk.sh"

     # install openstack
     stratosdev.vm.provision "shell", path: "scripts/openstack_setup.sh"

     # setup stratos development environment
     stratosdev.vm.provision "shell", path: "scripts/create_folders.sh"
     stratosdev.vm.provision "shell", path: "scripts/maven_setup.sh"
     stratosdev.vm.provision "shell", path: "scripts/desktop_setup.sh"
     stratosdev.vm.provision "shell", path: "scripts/stratos_developer_setup.sh"

     # setup stratos runtime
     stratosdev.vm.provision "shell", 
           inline: "rm -rf /home/vagrant/stratos"

     stratosdev.vm.provision "shell", path: "scripts/stratos_runtime_setup.sh"
     stratosdev.vm.provision "shell", path: "scripts/stratos_mb_setup.sh"
     stratosdev.vm.provision "shell", path: "scripts/stratos_cep_setup.sh"
     stratosdev.vm.provision "shell", 
           inline: "chown -R vagrant:vagrant /home/vagrant/stratos"

     # restart the box - FIXME this only really needs to happen after
     # the first provisioning run, not after every provision run
     stratosdev.trigger.after :provision, :execute => "vagrant reload"

  end

end
