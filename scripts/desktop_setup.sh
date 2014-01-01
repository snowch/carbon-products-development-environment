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

yum groupinstall -y "X Window System" Desktop
yum install -y firefox dkms xrdp
cp /etc/inittab /etc/inittab.bak 
sed -i 's/id:3:initdefault:/id:5:initdefault:/' /etc/inittab

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
# Openstack dashboard launcher
##############################


cat << EOF > /home/vagrant/Desktop/openstack.desktop
#!/usr/bin/env xdg-open

[Desktop Entry]
Version=1.0
Encoding=UTF-8
Exec=firefox %u http://localhost/dashboard
Icon=firefox
Terminal=false
Type=Application
StartupWMClass=Firefox-bin
MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;
StartupNotify=true
X-Desktop-File-Install-Version=0.15
Categories=Network;WebBrowser;
GenericName[en_US.UTF-8]=Openstack Dashboard
Comment[en_US.UTF-8]=Openstack Dashboard
Name[en_US]=Openstack Dashboard
EOF

chown vagrant:vagrant /home/vagrant/Desktop/openstack.desktop
chmod 770 /home/vagrant/Desktop/openstack.desktop

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

