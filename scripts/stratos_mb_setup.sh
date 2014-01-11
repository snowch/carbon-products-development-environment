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

########################################
#
# Setup Message Broker
#
########################################

STRATOS_DIR=/home/vagrant/stratos/
MB_URL=https://www.dropbox.com/sh/855iyfpjfnkoi2e/b-RFY_qDR1/wso2mb-2.1.0.zip
MB_HOME=/home/vagrant/stratos/wso2mb-2.1.0/

# Download and unpack message broker

wget -nv -c --no-check-certificate -O /vagrant/downloads/$(basename $MB_URL) $MB_URL
unzip -qq /vagrant/downloads/`basename ${MB_URL}` -d $STRATOS_DIR 

# Update port offset

sed -i 's/<Offset>0/<Offset>5/g' \
   ${MB_HOME}/repository/conf/carbon.xml

# Update memory settings
#   note that grep will die if string isn't found
#   for example if the upstream memory settings change

FIND="-Xms256m -Xmx1024m -XX:MaxPermSize=256m"
REPLACE="-Xms64m -Xmx256m -XX:MaxPermSize=128m"
MB_FILE=${MB_HOME}/bin/wso2server.sh

# grep needs first dash escaped

grep "\\${FIND}" $MB_FILE 

sed -i "s/${FIND}/${REPLACE}/g" ${MB_FILE}

