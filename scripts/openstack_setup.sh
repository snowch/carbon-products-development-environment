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

if [ -f /etc/openstack_provisioned_date ]
then
   echo "Openstack already provisioned so exiting."
   exit 0 
fi

yum -y install puppet git

cd /etc/puppet/modules
git clone git://github.com/stackforge/puppet-openstack.git openstack
cd openstack
gem install librarian-puppet
librarian-puppet install --path ../

puppet apply /vagrant/scripts/openstack.pp --certname openstack_all

# create a utility script for developers to start/stop openstack

cat << EOF > /home/vagrant/openstack.sh
#!/bin/sh

for script in /etc/init.d/openstack-*; 
do 
    sudo \$script \$1;
done
EOF

chmod +x /home/vagrant/openstack.sh
chown vagrant:vagrant /home/vagrant/openstack.sh

# lets restart openstack now because we have changed the nova.conf

/home/vagrant/openstack.sh restart


date > /etc/openstack_provisioned_date
