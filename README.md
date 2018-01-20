# pk2-app
Passkeeper2 app server:

https://cloud.digitalocean.com

Login

Droplets tab -> Create -> Droplet menu item

Choices:

    CentOS 7.4
    Standard Sizes, $10/mo
    Datacenter NYC1
    Private networking
    SSH keys: root-laptop, loco-laptop
    1 Droplet: pk2-app
    Add Tags: passkeeper2, appserv

#### Then:

SSH to root@<server-ipaddress>

    yum -y update &&
    yum install -y git

    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"
    git config --global push.default simple

    cd /opt &&
    git clone https://github.com/dpneumo/pk2-pg.git

    cd pk2-pg &&
    chmod 755 *.sh

    git update-index --add --chmod=+x *.sh
    git commit -m "make our scripts executable and tell git about it"
    git push

    ./config_server.sh  # Will ask for new password for user 'loco'

    exit

SSH to loco@<server-ipaddress>

    cd /opt/pk2-pg

    sudo ./scripts/ruby.sh
    sudo ./scripts/rails.sh
    sudo ./scripts/iptables.sh

### config_server.sh

This script does the initial setup of the server.

* Nano, expect and tcl are installed.
* A user (loco) is created with sudo privileges.
* SSH is setup to allow key authentication and disallow password authentication.
* SSH root login is disallowed.
* sshd is restarted and enabled for start at boot.

### ruby.sh

Set up ruby

* Install ruby
* Add Bundler

### rails.sh

Set up rails

* Install rails

### iptables.sh

Set up iptables

* Install iptables
* Install iptables rules and make them permanent
* Turn off firewalld and turn on iptables
* Setup iptables logging
