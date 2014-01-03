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

MAVEN_DOWNLOAD_URL=http://www.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz


if [ ! -d /opt/apache-maven-3.0.5 ]
then
   wget -nv -c -P /vagrant/downloads/ $MAVEN_DOWNLOAD_URL
   su -c "tar -zxvf /vagrant/downloads/apache-maven-3.0.5-bin.tar.gz -C /opt/" 
fi

cat << EOF > /etc/profile.d/maven.sh
M2_HOME=/opt/apache-maven-3.0.5
export M2_HOME

M2=\$M2_HOME/bin
export M2

PATH=\$M2:$PATH
export PATH
EOF

