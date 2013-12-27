#!/bin/bash

set -e
set -x

yum groupinstall -y "X Window System" Desktop
yum install -y firefox
cp /etc/inittab /etc/inittab.bak 
sed -i 's/id:3:initdefault:/id:5:initdefault:/' /etc/inittab

###############
# setup eclipse
###############

wget http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/luna/M4/eclipse-jee-luna-M4-linux-gtk-x86_64.tar.gz
su -c "tar -zxvf eclipse-jee-luna-M4-linux-gtk-x86_64.tar.gz -C /home/vagrant/"
chown -R vagrant:vagrant /home/vagrant/eclipse
rm /root/eclipse-jee-luna-M4-linux-gtk-x86_64.tar.gz

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
Icon=eclipse
Exec=/home/vagrant/eclipse/eclipse -data /home/vagrant/workspace
Terminal=false
Categories=Development;IDE;Java;
EOF

chown vagrant:vagrant /home/vagrant/Desktop/eclipse.desktop
chmod 770 /home/vagrant/Desktop/eclipse.desktop
