#!/bin/bash
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

set -e
set -x

if [ -f /etc/desktop_provisioned_date ]
then
   echo "Desktop already provisioned so exiting."
   exit 0
fi

#################
# Install desktop
#################

yum -y groupinstall "Desktop" "Desktop Platform" "X Window System" "Fonts"
yum install -y firefox gedit

#cp /etc/inittab /etc/inittab.bak 
#sed -i 's/id:3:initdefault:/id:5:initdefault:/' /etc/inittab

yum install -y tigervnc-server libtool automake \
   gcc openssl-devel pam-devel libX11-devel libXfixes-devel 

wget http://downloads.sourceforge.net/project/xrdp/xrdp/0.6.1/xrdp-v0.6.1.tar.gz

rm -rf xrdp-v0.6.1 # clean up from previous runs
tar -zxvf xrdp-v0.6.1.tar.gz
rm -f xrdp-v0.6.1.tar.gz
cd xrdp-v0.6.1
./bootstrap
./configure
make
make install
cp -f /etc/xrdp/xrdp.sh /etc/init.d/
/sbin/chkconfig --add xrdp.sh
service xrdp.sh restart

# TODO set /etc/xrdp/xrdp.ini
# [xrdp1]
# ...
# username=vagrant
# password=vagrant
# ...

iptables -I INPUT 1 -p tcp --dport 3389 -j ACCEPT
iptables-save | sudo tee /etc/sysconfig/iptables
service iptables restart


###############
# setup eclipse
###############

wget -nv -c -P /vagrant/downloads/ http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/luna/M4/eclipse-jee-luna-M4-linux-gtk-x86_64.tar.gz
su -c "tar -zxvf /vagrant/downloads/eclipse-jee-luna-M4-linux-gtk-x86_64.tar.gz -C /home/vagrant/"
chown -R vagrant:vagrant /home/vagrant/eclipse

if [ ! -d /home/vagrant/Desktop ]
then
   mkdir /home/vagrant/Desktop
fi
chown vagrant:vagrant /home/vagrant/Desktop

##############################
# eclipse launcher
##############################

cat << EOF > /home/vagrant/Desktop/eclipse.desktop
#!/usr/bin/env xdg-open

[Desktop Entry]
Type=Application
Name=Eclipse
Comment=Eclipse Integrated Development Environment
Icon=/home/vagrant/eclipse/icon.xpm
Exec=/home/vagrant/eclipse/eclipse -data /home/vagrant/workspace
Terminal=false
Categories=Development;IDE;Java;
EOF

chown vagrant:vagrant /home/vagrant/Desktop/eclipse.desktop
chmod 770 /home/vagrant/Desktop/eclipse.desktop

######

date > /etc/desktop_provisioned_date

