# pk2-app
The app server part of pk2

https://cloud.digitalocean.com

Login

Droplets tab => Create => Droplet menu item

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

    yum -y update && yum -y install git

    cd /opt && git clone https://github.com/dpneumo/pk2-app.git
    chown -R loco:loco pk2-app

    cd pk2-app && chmod 755 *.sh && chmod 755 **/*.sh

    # git global env vars will be set for each user
    cat data/git_global_env_vars > /etc/profile.d/git.sh
    chmod 0644 /etc/profile.d/git.sh

    ./config_server.sh  # Will ask for new password for user 'loco'

    exit

SSH to loco@<server-ipaddress>

    cd /opt/pk2-app

    git update-index --add --chmod=+x **/*.sh
    ./scripts/git.sh
    git commit -m "make our scripts executable and tell git about it"
    git push

    sudo ./scripts/iptables.sh
    ./scripts/ruby.sh  # Will ask for password for user 'loco' 1-2 times.
    ./scripts/rails.sh # Will ask for password for user 'loco' 1-2 times.

    exit # Re-login to assure env vars are picked up

### config_server.sh
This script does the initial setup of the server.
* Nano, expect and tcl are installed.
* A user (loco) is created with sudo privileges.
* SSH is setup to allow key authentication and disallow password authentication.
* SSH root login is disallowed.
* sshd is restarted and enabled for start at boot.

### git.sh
* Initialize git for the loco user

### iptables.sh
Set up iptables
* Install iptables
* Install iptables rules and make them permanent
* Turn off firewalld and turn on iptables
* Setup iptables logging

### ruby.sh
Set up ruby
* Install ruby
* Add Bundler

### rails.sh
Set up rails
* Install rails
