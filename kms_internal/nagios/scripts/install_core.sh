#!/bin/bash

set -e 

sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

sudo yum install -y gcc glibc glibc-common wget unzip httpd php gd gd-devel perl postfix
sudo yum install -y openssl-devel perl-Net-SNMP make gettext automake autoconf net-snmp net-snmp-utils epel-release

cd /tmp
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.14.tar.gz
tar xzf nagioscore.tar.gz

cd /tmp/nagioscore-nagios-4.4.14/
./configure
sudo make all

sudo make install-groups-users
sudo usermod -a -G nagios apache
sudo make install

sudo make install-daemoninit
sudo systemctl enable httpd.service

sudo make install-commandmode
sudo make install-config
sudo make install-webconf

sudo firewall-cmd --zone=public --add-port=80/tcp
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd reload

sudo systemctl start httpd.service
sudo systemctl start nagios.service

cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.4.6.tar.gz
tar zxf nagios-plugins.tar.gz

cd /tmp/nagios-plugins-release-2.4.6/
./tools/setup
./configure
sudo make
sudo make install

sudo systemctl start nagios.service
sudo systemctl stop nagios.service
sudo systemctl restart nagios.service
sudo systemctl status nagios.service

cd /tmp
wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.2.1/nrpe-3.2.1.tar.gz
tar xzf nrpe-3.2.1.tar.gz
cd nrpe-3.2.1
./configure
sudo make check_nrpe
sudo make install-plugin

# Run this command in SSH shell
# htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
