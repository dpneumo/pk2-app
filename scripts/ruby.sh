#!/bin/bash

# Add HTTP & HTTPS Client rules - temporary for yum
sudo sh -c "
  iptables -A wan_in  -p tcp --sport 80  -m state --state ESTABLISHED     -j ACCEPT;
  iptables -A wan_out -p tcp --dport 80  -m state --state NEW,ESTABLISHED -j ACCEPT;
  iptables -A wan_in  -p tcp --sport 443 -m state --state ESTABLISHED     -j ACCEPT;
  iptables -A wan_out -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT;
  /sbin/service iptables save;

  # ruby-build build environment;
  yum install -y gcc bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel"


# rbenv
RBENV="$HOME/.rbenv"
if [ -d "$RBENV" ]; then
  echo "rbenv is already installed."
else
  git clone https://github.com/rbenv/rbenv.git "$RBENV"
  cd ~/.rbenv && src/configure && make -C src
fi

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile


# ruby-build as rbenv plugin
RUBYBUILD="$RBENV/plugins/ruby-build"
if [ -d "$RUBYBUILD" ]; then
  echo "ruby-build plugin is already installed."
else
  mkdir -p "$RUBYBUILD/plugins"
  git clone https://github.com/rbenv/ruby-build.git "$RUBYBUILD"
fi


# Install Ruby 2.5.0
RUBY250="$RBENV/versions/2.5.0/bin/ruby"
if [ -e "$RUBY250" ]; then
  echo "Ruby 2.5.0 already installed by rbenv."
else
  echo "Ruby will be installed."
  rbenv install 2.5.0
fi
rbenv global 2.5.0
rbenv rehash
gem install bundler
rbenv rehash


# Remove HTTP & HTTPS Client rules
sudo sh -c "
  iptables -D wan_in  -p tcp --sport 80  -m state --state ESTABLISHED     -j ACCEPT;
  iptables -D wan_out -p tcp --dport 80  -m state --state NEW,ESTABLISHED -j ACCEPT;
  iptables -D wan_in  -p tcp --sport 443 -m state --state ESTABLISHED     -j ACCEPT;
  iptables -D wan_out -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT;
  /sbin/service iptables save"

### Notes: ###
# If compilation fails with a readline error, specify the location of libreadline.so in the with-readline-dir build flag. For example:
# RUBY_CONFIGURE_OPTS="--with-readline-dir=/usr/lib" rbenv install 2.4.0
