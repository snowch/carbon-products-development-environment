#!/bin/bash

set -e
set -x

sudo yum install -y http://rdo.fedorapeople.org/rdo-release.rpm
sudo yum install -y openstack-packstack expect

expect << EOF
set timeout -1
spawn "/usr/bin/packstack" "--allinone"
expect "Setting up ssh keys...root@10.0.2.15's password:"
send "vagrant\n"
expect eof
EOF
