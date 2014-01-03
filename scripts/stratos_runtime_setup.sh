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

while getopts "f" opt; do
  case $opt in
    f)
      rm -f /etc/stratos_runtime_provisioned_date
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit -1
      ;;
  esac
done

if [ -f /etc/stratos_runtime_provisioned_date ]
then
   echo "Stratos runtime already provisioned so exiting."
   exit 0
fi

#############################
#
# Setup Java
#
#############################

yum install -y git java-1.7.0-openjdk-devel

cat << EOF > /etc/profile.d/set_javahome.sh
JAVA_HOME=/usr/lib/jvm/java-1.7.0
export JAVA_HOME
EOF



# stratos version
ST_VN=4.0.0-SNAPSHOT

# the directory containing the products
PROD_DIR=/home/vagrant/.m2/repository/org/apache/stratos/

# the stratos installer folder
STRATOS_PACK_DIR=/home/vagrant/stratos


# mkdir if it doesn't exist
if [ ! -d ${STRATOS_PACK_DIR} ]
then
   mkdir $STRATOS_PACK_DIR
fi

# remove any previous files 
rm -rf $STRATOS_PACK_DIR/*

########################################
#
# Setup Stratos Products
#
########################################

PRODUCTS=(
  cc/apache-stratos-cc/${ST_VN}/apache-stratos-cc-${ST_VN}.zip
  apache-stratos-sc/${ST_VN}/apache-stratos-sc-${ST_VN}.zip
  load/balancer/apache-stratos-load-balancer/${ST_VN}/apache-stratos-load-balancer-${ST_VN}.zip
  apache-stratos-cartridge-agent/${ST_VN}/apache-stratos-cartridge-agent-${ST_VN}-bin.zip
  apache-stratos-cli/${ST_VN}/apache-stratos-cli-${ST_VN}.zip
)

for item in ${PRODUCTS[*]}
do
   unzip -qq ${PROD_DIR}${item} -d $STRATOS_PACK_DIR
done

###############
# Finished
###############

date > /etc/stratos_runtime_provisioned_date
