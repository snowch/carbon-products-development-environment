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

if [ $# -eq 0 ]
then
  echo "Usage: $0 turning_chunk_version"
  exit 1
else
  CHUNK=$(echo $1 | perl -p -e 's/\s*//g')  # strip whitespace & newlines
fi

if [ -f /etc/developer_provisioned_date ]
then
   echo "Stratos developer already provisioned so exiting."
   exit 0
fi

SVN_URL=https://svn.wso2.org/repos/wso2/carbon/platform/tags/turing-chunk${CHUNK}

CARBON_SRC=/home/vagrant/carbon-source

MAVEN_SETTINGS=/vagrant/maven_settings.xml

############################
# checkout and build carbon
############################

yum install -y subversion

if [ -d $CARBON_SRC ]; 
then
   # FIXME if the CHUNK number has changed since checking out, we 
   # should delete and re-checkout
   sudo -i -u vagrant \
      svn up $CARBON_SRC
else
   sudo -i -u vagrant \
      svn checkout $SVN_URL \
      $CARBON_SRC
fi

# FIXME use xmlstar let to search for all products and exclude 
# all but the required product

# prevent apimgt build
sed -i -e 's:<module>\(.*/apimgt/.*\)</module>:<!--module>\1</module-->:g' \
       $CARBON_SRC/product-releases/chunk-$CHUNK/products/pom.xml

# prevent ss build
sed -i -e 's:<module>\(.*/ss/.*\)</module>:<!--module>\1</module-->:g' \
       $CARBON_SRC/product-releases/chunk-$CHUNK/products/pom.xml

# must be build with tests - see:
# http://wso2-oxygen-tank.10903.n7.nabble.com/Dev-Platform-build-failure-4-1-2-patch-release-td77798.html
sudo -i -u vagrant \
   $M2_HOME/bin/mvn -B \
   -f $CARBON_SRC/product-releases/chunk-${CHUNK}/products/pom.xml \
   -s $MAVEN_SETTINGS \
   -l /vagrant/log/mvn_clean_install.log \
   clean install \
   --fail-never

#####################
# maven eclipse setup
#####################

# perform mvn eclipse:eclipse

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -B \
   -f $CARBON_SRC/product-releases/chunk-${CHUNK}/products/pom.xml \
   -s $MAVEN_SETTINGS \
   -l /vagrant/log/mvn_eclipse_eclipse.log \
   -D downloadSources=true \
   eclipse:eclipse 

# we need an eclipse plugin that will perform the headless import
# of projects into the workspace

sudo -i -u vagrant \
   wget -P /home/vagrant/eclipse/dropins/ \
      https://github.com/snowch/test.myapp/raw/master/test.myapp_1.0.0.jar

# get all the directories that can be imported into eclipse and append them
# with '-import'

IMPORTS=$(find ${CARBON_SRC} -type f -name .project)

read -ra IMPORTS_ARR <<< $IMPORTS

IMPORTS_LEN=${#IMPORTS_ARR[@]}

# Although it is possible to import multiple directories with one 
# invocation of the test.myapp.App, this fails if one of the imports
# was not successful.  Using a for loop is slower, but more robust
for ((i=0; i<${IMPORTS_LEN}; i++)) 
{
   IMPORT="$(dirname ${IMPORTS_ARR[$i]})/"
   echo "Importing ${IMPORT}"

   # the last import should trigger a build
   if [ "$i" == "$(($IMPORTS_LEN-1))" ]
   then
      BUILD_FLAG="-build"
   else
      unset BUILD_FLAG
   fi

   # perform the import
   sudo -i -u vagrant \
      /home/vagrant/eclipse/eclipse -nosplash \
      -application test.myapp.App \
      -data /home/vagrant/workspace \
      -import $IMPORT $BUILD_FLAG
}

# add the M2_REPO variable to the workspace

sudo -i -u vagrant \
   $M2_HOME/bin/mvn -B -f $CARBON_SRC/pom.xml \
   -s $MAVEN_SETTINGS \
   -l /vagrant/log/mvn_eclipse_configure_workspace.log \
   -Declipse.workspace=/home/vagrant/workspace/ \
   eclipse:configure-workspace


date > /etc/developer_provisioned_date 
