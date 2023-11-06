#!/bin/bash

set -e

sudo apt update && sudo apt upgrade
sudo apt install -y libssl-dev build-essential net-tools

cd /tmp
wget http://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
tar xzf nagios-plugins-2.2.1.tar.gz
cd nagios-plugins-2.2.1

./configure
sudo make --enable-command-args
sudo make install
sudo useradd nagios
sudo groupadd nagios
sudo usermod -aG nagios nagios
sudo chown nagios.nagios /usr/local/nagios
sudo chown -R nagios.nagios /usr/local/nagios/libexec

cd /tmp
wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.2.1/nrpe-3.2.1.tar.gz
tar xzf nrpe-3.2.1.tar.gz
cd nrpe-3.2.1

./configure
sudo make all
sudo make install
sudo make install-config
sudo make install-init
sudo systemctl enable nrpe && sudo systemctl start nrpe 

sudo ufw enable
sudo ufw allow 22
sudo ufw allow 5666
sudo ufw reload




