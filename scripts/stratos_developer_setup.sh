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

# Note: this script should be idempotent

set -e
set -x

STRATOS_SRC=/home/vagrant/incubator-stratos

MAVEN_SETTINGS=/vagrant/maven_settings.xml

############################
# checkout and build stratos
############################

yum install -y git java-1.7.0-openjdk-devel

if [ -d $STRATOS_SRC ]; 
then
   # TODO should we do an update
   echo 'Found stratos src folder.  Not updating.'
else
   sudo -i -u vagrant \
      git clone https://git-wip-us.apache.org/repos/asf/incubator-stratos.git \
      $STRATOS_SRC
fi

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -B -f $STRATOS_SRC/pom.xml \
   -s $MAVEN_SETTINGS \
   -l /vagrant/log/stratos_mvn_clean_install.log clean install

echo "built distributions after first build ..."

find incubator-stratos/products/ -name *.zip | grep distribution

######################################################
# FIXME
# hack to build cloud controller distribution
# https://github.com/snowch/vagrant-packstack/issues/1 
######################################################

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -B -f $STRATOS_SRC/pom.xml \
   -s $MAVEN_SETTINGS \
   -l /vagrant/log/stratos_mvn_clean_install2.log install

echo "built distributions after second build ..."

find incubator-stratos/products/ -name *.zip | grep distribution

#####################
# maven eclipse setup
#####################

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -B -f $STRATOS_SRC/pom.xml \
   -s $MAVEN_SETTINGS \
   -l /vagrant/log/stratos_mvn_eclipse_eclipse.log eclipse:eclipse
