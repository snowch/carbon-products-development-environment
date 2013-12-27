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

yum install -y java-1.7.0-openjdk-devel git 

#############
# setup maven
#############

wget http://mirrors.gigenet.com/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
su -c "tar -zxvf apache-maven-3.0.5-bin.tar.gz -C /opt/" 
rm /root/apache-maven-3.0.5-bin.tar.gz

cat << EOF > /etc/profile.d/maven.sh
export M2_HOME=/opt/apache-maven-3.0.5
export M2=\$M2_HOME/bin
export PATH=$M2:$PATH
EOF

############################
# checkout and build stratos
############################

sudo -i -u vagrant \
   git clone https://git-wip-us.apache.org/repos/asf/incubator-stratos.git 

M2_HOME=/opt/apache-maven-3.0.5
STRATOS_SRC=/home/vagrant/incubator-stratos

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -f $STRATOS_SRC/pom.xml clean install

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -f $STRATOS_SRC/pom.xml eclipse:eclipse
