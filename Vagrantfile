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


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "centos64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

  config.vm.provider :virtualbox do |vb|
     vb.gui = true
     vb.customize ["modifyvm", :id, "--memory", "5120"]
  end

  config.vm.provision "shell", path: "openstack_setup.sh"

  if INSTALL_DESKTOP
     config.vm.provision "shell", path: "desktop_setup.sh"
  end

  config.vm.provision "shell", path: "stratos_developer_setup.sh"
  config.vm.provision "shell", inline: "sudo reboot"

end
