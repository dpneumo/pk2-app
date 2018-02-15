#!/bin/bash

# Add HTTP & HTTPS Client rules - temporary for yum & git
sudo sh -c "
  iptables -A wan_in  -p tcp --sport 80  -m state --state ESTABLISHED     -j ACCEPT;
  iptables -A wan_out -p tcp --dport 80  -m state --state NEW,ESTABLISHED -j ACCEPT;
  iptables -A wan_in  -p tcp --sport 443 -m state --state ESTABLISHED     -j ACCEPT;
  iptables -A wan_out -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT;
  /sbin/service iptables save;"

# Development tools
sudo yum -y groupinstall 'Development Tools'
sudo yum install -y gcc-c++ make sqlite-devel

# https://yarnpkg.com/en/docs/install (Centos7)
sudo wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
curl --silent --location https://rpm.nodesource.com/setup_6.x | sudo bash -
sudo yum install -y nodejs yarn

# Clone the app
cd ~
if [ -d "pk2" ]; then rm -R pk2; fi
git clone https://github.com/dpneumo/pk2.git

cd pk2
bundle install

# Remove HTTP & HTTPS Client rules
sudo sh -c "
  iptables -D wan_in  -p tcp --sport 80  -m state --state ESTABLISHED     -j ACCEPT;
  iptables -D wan_out -p tcp --dport 80  -m state --state NEW,ESTABLISHED -j ACCEPT;
  iptables -D wan_in  -p tcp --sport 443 -m state --state ESTABLISHED     -j ACCEPT;
  iptables -D wan_out -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT;
  /sbin/service iptables save"
