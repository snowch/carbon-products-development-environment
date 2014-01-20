Carbon Platform Developer Environment
=====================================

The aim of this project is to automate setting up development environments for Carbon 
Products.

In essence, this project:

- creates a CentOS guest
- sets up up XRDP remote desktop server
- sets up up maven, subversion, java
- checks out carbon source
- performs mvn clean install
- performs mvn eclipse:eclipse
- creates an eclipse workspace and imports the projects 

Prerequisites
-------------
Install the following software:
- Vagrant: http://www.vagrantup.com/downloads
- Virtualbox: https://www.virtualbox.org/wiki/Downloads

It is recommended to install the vagrant plugins using **vagrant plugin install ...**:

- ```vagrant plugin install vagrant-cachier```
- ```vagrant plugin install vagrant-vbguest```
- ```vagrant plugin install vagrant-triggers```

Issues
------
Proxy support is untested and not documented.  If you are working behind a proxy, 
please let me know and I can focus on improving proxy support.

Usage
=====

Checkout this project, e.g. 

```$ git clone https://github.com/snowch/carbon-products-development-environment```

Change into the project directory, e.g.

```cd carbon-products-development-environment```

Start the guest machine, e.g.

```vagrant up```

Wait.  Wait.  Wait.  Checking out the source and building it can easily take 12 hours or more.

Use a Remote Desktop Client to connect to the machine from the host, e.g.

- Windows: Remote Desktop Client, set Computer: ```localhost:4480```
- Linux: ```rdesktop localhost:4480```

Remote Desktop details:

- Hostname: localhost:8080
- Username: vagrant
- Password: vagrant


Description
===========

The environment is setup with shell scripts.

The scripts are executed in the order they are found in the Vagrantfile.  Scripts are
executed by this statement:

```carbon.vm.provision "shell", path: "scriptpath/scriptname.sh"```

The scripts can be found in the ```scripts``` folder.
