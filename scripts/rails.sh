#!/bin/bash

# Add HTTP & HTTPS Client rules - temporary for yum & git
sudo sh -c "
  iptables -A wan_in  -p tcp --sport 80  -m state --state ESTABLISHED     -j ACCEPT;
  iptables -A wan_out -p tcp --dport 80  -m state --state NEW,ESTABLISHED -j ACCEPT;
  iptables -A wan_in  -p tcp --sport 443 -m state --state ESTABLISHED     -j ACCEPT;
  iptables -A wan_out -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT;
  /sbin/service iptables save;"

# Development tools
sudo yum -y group install 'Development Tools'
sudo yum install -y gcc-c++ make sqlite-devel

# https://yarnpkg.com/en/docs/install (Centos7)
sudo wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
curl --silent --location https://rpm.nodesource.com/setup_6.x | sudo bash -
sudo yum -y install -y nodejs yarn

# Install pg gem. Needs postgres client, dev files and libs.
# These are installed in /usr/pgsql-10/
# Useful: sudo yum list | grep postgresql
sudo yum -y install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
sudo yum -y install postgresql10.x86_64 postgresql10-devel.x86_64 postgresql10-libs.x86_64
gem install pg -- --with-pg-config=/usr/pgsql-10/bin/pg_config

# Clone the app
cd ~
if [ -d "pk2" ]; then rm -Rf pk2; fi
git clone https://github.com/dpneumo/pk2.git

# Set default RAILS_ENV to be production
echo 'export RAILS_ENV=production' >> ~/.bash_profile
source ~/.bash_profile

# Install gems from Gemfile
cd pk2
bundle install

# Remove HTTP & HTTPS Client rules
sudo sh -c "
  iptables -D wan_in  -p tcp --sport 80  -m state --state ESTABLISHED     -j ACCEPT;
  iptables -D wan_out -p tcp --dport 80  -m state --state NEW,ESTABLISHED -j ACCEPT;
  iptables -D wan_in  -p tcp --sport 443 -m state --state ESTABLISHED     -j ACCEPT;
  iptables -D wan_out -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT;
  /sbin/service iptables save"
