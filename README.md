Stratos Developer Tools
=======================

The aim of this project is to provide tools for developers working on 
Apache Stratos to quickly set up development environments.  This project 
uses Vagrant and bash shell scripts to automatically provision there environment.

The setup uses shell scripts because the scripts pretty much mirror the manual setup instructions for stratos.  Therefore, the manual setup instructions can be followed, but the setup can be automated.  This will be more beneficial to users who are new to stratos.

This project is a work-in-progress.  There is still much to be done to configure the environments to work with each other.

Prerequisites
-------------
Install the following software:
- Vagrant: http://www.vagrantup.com/downloads
- Virtualbox: https://www.virtualbox.org/wiki/Downloads

It is recommended to install the vagrant plugins using **vagrant plugin install ...**:

- ```vagrant plugin install vagrant-cachier```
- ```vagrant plugin install vagrant-vbguest```

Issues
------
Proxy support is untested and not documented.  If you are working behind a proxy, 
please let me know and I can focus on improving proxy support.

Stratos Development Environment
-------------------------------
Vagrant provisions this environment from a CentOS 6.4 base image and some fairly
crude bash shell scripts that:

- install the CentOS desktop environment
- install git
- install maven
- checkout the stratos source
- build the stratos source
- install eclipse
- import the stratos source into eclipse

The scripts are fairly easy to understand.  They can be found here:

     scripts/create_folders.sh
     scripts/maven_setup.sh
     scripts/desktop_setup.sh
     scripts/stratos_developer_setup.sh

To start the development environment, checkout the git repo, change to the directory
containing the Vagrantfile and run ```vagrant up stratosdev```.  This will
take quiet some time and downloads quite a lot of data.

After the virtual machine has started up, you can connect to it using 
Microsoft Remote Desktop Connection or rdesktop on Linux or Mac OS/X

- **Host**: localhost
- **Port**: 4480
- **Username**: vagrant
- **Password**: vagrant

On the desktop is an Eclipse icon.  Double click to open.  
The eclipse workspace is setup with all Stratos eclipse projects imported.  
After opening, wait for the workspace to finish building.  
You can see the build status in the bottom right of the 
eclipse window.  After building in eclipse, there should be no build errors.


Stratos Runtime
---------------

Note: work on setting up the runtime has only just started. 

The following scripts have been completed for setting up the runtime:

  - scripts/stratos_runtime_setup.sh
  - scripts/stratos_mb_setup.sh
  - scripts/stratos_cep_setup.sh

TODO: scripts will be required for all the other stratos components


Openstack
---------

This environment is a CentOS 6.4 image that gets provisioned with openstack
using the **packstack --allinone** installer.  
See here: http://openstack.redhat.com/Quickstart

Openstack is setup with this script:

  - scripts/openstack_setup.sh

