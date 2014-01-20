Carbon Platform Developer Environment
=====================================

The aim of this project is to automate setting up development environments for Carbon 
Products.

In essence, this project:

- creates a CentOS guest
- sets up up XRDP remote desktop server
- sets up up maven, subversion, java
- checks out carbon source
- performs mvn clean install (on chunk-05)
- performs mvn eclipse:eclipse (on chunk-05)
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

This project has been tested with 6GB memory settings.  If you want to try with
lower memory requirements, try changing this line in the Vagrantfile:

```vb.customize ["modifyvm", :id, "--memory", "6144"]```


Issues
------
Proxy support is untested and not documented.  If you are working behind a proxy, 
please let me know and I can focus on improving proxy support.  If you don't want to
wait for me, you can try the instructions for setting up a proxy, as described here:

https://github.com/tmatilai/vagrant-proxyconf

Usage
-----

Checkout this project, e.g. 

```$ git clone https://github.com/snowch/carbon-products-development-environment```

Change into the project directory, e.g.

```cd carbon-products-development-environment```

Start the guest machine, e.g.

```vagrant up```

Wait.  Wait.  Wait.  Checking out the source and building it can easily take a few hours or more to finish.

When you see:

```
******************************************************************************************
* FINISHED SETTING UP DEVELOPMENT ENVIRONMENT - Performing 'vagrant reload' to reboot    *
******************************************************************************************
[carbon] Configuring cache buckets...
[carbon] Running triggers after action...
[carbon] Executing command "vagrant reload"...
```

... you can use a Remote Desktop Client to connect to the machine from the host, e.g.

- Windows: Remote Desktop Client, set Computer: ```localhost:4480```
- Linux: ```rdesktop localhost:4480```

Remote Desktop details:

- Hostname: localhost:8080
- Username: vagrant
- Password: vagrant


Description
-----------

The environment is setup with shell scripts.

The scripts are executed in the order they are found in the Vagrantfile.  Scripts are
executed by this statement:

```carbon.vm.provision "shell", path: "scriptpath/scriptname.sh"```

The scripts can be found in the ```scripts``` folder.

Screenshot
----------

After ```vagrant up``` has completed, you can open eclipse using the desktop icon. Your environment is setup for you.  Eclipse will be trying to build.

Also shown is ```mvn clean install``` typed into a shell window.  Nothing else needed to be done except open the Terminal (under System Tools).

![alt tag](https://raw2.github.com/snowch/carbon-products-development-environment/ac772ce9ad83e33319486a4c84500946c24c5633/doc/eclipse_screenshot.png)

How to remove
-------------

The nice thing about Vagrant is that it will not mess with your existing java environment.  When you have had enough of the development environment, all you need to do to remove is the following:

- Perform ```vagrant destroy``` from the same directory that you ran ```vagrant up```.
- Uninstall Vagrant
- Uninstall Virtualbox
