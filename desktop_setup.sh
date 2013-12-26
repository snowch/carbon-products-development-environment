#!/bin/bash

set -e
set -x

yum groupinstall -y "X Window System" Desktop
yum install -y firefox
cp /etc/inittab /etc/inittab.bak 
sed -i 's/id:3:initdefault:/id:5:initdefault:/' /etc/inittab
