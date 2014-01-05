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

# This script depends on eclipse being installed to 
# /home/vagrant/eclipse

set -e
set -x

if [ -f /etc/stratos_developer_provisioned_date ]
then
   echo "Stratos developer already provisioned so exiting."
   exit 0
fi

STRATOS_SRC=/home/vagrant/incubator-stratos

MAVEN_SETTINGS=/vagrant/maven_settings.xml

############################
# checkout and build stratos
############################

yum install -y git java-1.7.0-openjdk-devel

if [ -d $STRATOS_SRC ]; 
then
   # TODO should we do an update
   echo 'Found stratos src folder.  Not updating git.'
else
   sudo -i -u vagrant \
      git clone https://git-wip-us.apache.org/repos/asf/incubator-stratos.git \
      $STRATOS_SRC
fi

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -B -f $STRATOS_SRC/pom.xml \
   -s $MAVEN_SETTINGS \
   -l /vagrant/log/stratos_mvn_clean_install.log clean install dependency:go-offline

#####################
# maven eclipse setup
#####################

# perform mvn eclipse:eclipse

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -B -f $STRATOS_SRC/pom.xml \
   -s $MAVEN_SETTINGS \
   -l /vagrant/log/stratos_mvn_eclipse_eclipse.log \
   -o eclipse:eclipse 

# we need an eclipse plugin that will perform the headless import
# of projects into the workspace

sudo -i -u vagrant \
   wget -P /home/vagrant/eclipse/dropins/ \
      https://github.com/snowch/test.myapp/raw/master/test.myapp_1.0.0.jar

# get all the directories that can be imported into eclipse and append them
# with '-import'

IMPORTS=`find /home/vagrant/incubator-stratos/ -type f -name .project`

# prepend '-import' to the first project directory
IMPORTS="-import $IMPORTS" 

# strip off the .project from the filename and add a '-import' 
IMPORTS=`echo $IMPORTS | sed 's/.project / -import /g'` 

# strip off the final .project
IMPORTS=`echo $IMPORTS | sed 's/.project$//g'`

# perform the import

sudo -i -u vagrant \
   /home/vagrant/eclipse/eclipse -nosplash \
   -application test.myapp.App \
   -data /home/vagrant/workspace $IMPORTS

# add the M2_REPO variable to the workspace

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -B -f $STRATOS_SRC/pom.xml \
   -s $MAVEN_SETTINGS \
   -l /vagrant/log/stratos_mvn_eclipse_configure_workspace.log \
   -Declipse.workspace=/home/vagrant/workspace/ \
   eclipse:configure-workspace

######################################################
# FIXME
# hack to build cloud controller distribution
# https://github.com/snowch/vagrant-packstack/issues/1 
######################################################

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -B \
   -f $STRATOS_SRC/products/cloud-controller/modules/distribution/pom.xml \
   -s $MAVEN_SETTINGS \
   -l /vagrant/log/stratos_mvn_install.log \
   -o install


date > /etc/stratos_developer_provisioned_date 
