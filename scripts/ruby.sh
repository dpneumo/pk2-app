# Add HTTP Client rules - temporary for yum
iptables -A wan_in  -p tcp --sport 80  -m state --state ESTABLISHED     -j ACCEPT
iptables -A wan_out -p tcp --dport 80  -m state --state NEW,ESTABLISHED -j ACCEPT
/sbin/service iptables save

# ruby-build build environment
sudo -u ${USERNAME} yum install -y gcc bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

# Remove HTTP Client rules
iptables -D wan_in  -p tcp --sport 80  -m state --state ESTABLISHED     -j ACCEPT
iptables -D wan_out -p tcp --dport 80  -m state --state NEW,ESTABLISHED -j ACCEPT
/sbin/service iptables save


# rbenv
sudo -u ${USERNAME} git clone https://github.com/rbenv/rbenv.git ~/.rbenv
sudo -u ${USERNAME} cd ~/.rbenv && src/configure && make -C src
sudo -u ${USERNAME} echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
sudo -u ${USERNAME} source ~/.bash_profile

# ruby-build as rbenv plugin
sudo -u ${USERNAME} mkdir -p "$(rbenv root)"/plugins
sudo -u ${USERNAME} git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build


# Add general HTTPS Client rules -  temporary for ruby install
iptables -A wan_in  -p tcp --sport 443 -m state --state ESTABLISHED     -j ACCEPT
iptables -A wan_out -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
/sbin/service iptables save

# Install Ruby 2.4.0
sudo -u ${USERNAME} rbenv install 2.4.0

# Remove general HTTPS Client rules
iptables -D wan_in  -p tcp --sport 443 -m state --state ESTABLISHED     -j ACCEPT
iptables -D wan_out -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
/sbin/service iptables save

### Notes: ###
# If compilation fails with a readline error, specify the location of libreadline.so in the with-readline-dir build flag. For example:
# RUBY_CONFIGURE_OPTS="--with-readline-dir=/usr/lib" rbenv install 2.4.0
