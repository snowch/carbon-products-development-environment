#!/bin/bash

set -e
set -x

yum install -y java-1.7.0-openjdk-devel git eclipse-jdt

sudo -i -u vagrant \
   git clone https://git-wip-us.apache.org/repos/asf/incubator-stratos.git 

wget http://mirrors.gigenet.com/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
su -c "tar -zxvf apache-maven-3.0.5-bin.tar.gz -C /opt/" 

cat << EOF > /etc/profile.d/maven.sh
export M2_HOME=/opt/apache-maven-3.0.5
export M2=\$M2_HOME/bin
export PATH=$M2:$PATH
EOF

M2_HOME=/opt/apache-maven-3.0.5
STRATOS_SRC=/home/vagrant/incubator-stratos

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -f $STRATOS_SRC/pom.xml clean install

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -f $STRATOS_SRC/pom.xml eclipse:eclipse
