#!/bin/bash

# Provisioning Server Initial Preparation
# Run as root BEFORE disabling ssh login as root
# Run from simple_salt_master root dir

# Script:
yum update -y
yum install -y nano expect tcl mlocate

# Setup a new user for ssh login
if sudo -u loco whoami > /dev/null;
then
  echo "User loco already exists. Set up manually."
else
  # Create user: loco with sudo priv
  useradd loco
  passwd loco
  usermod -aG wheel loco
  echo "Added user loco"

  # Setup ssh for loco
  # Set appropriate ownership and permissions - ssh is picky!
  mkdir -p /home/loco/.ssh
  touch /home/loco/.ssh/authorized_keys
  cat data/loco_pubkey >> /home/loco/.ssh/authorized_keys
  chmod 700 /home/loco/.ssh
  chmod 600 /home/loco/.ssh/authorized_keys
  chown loco:loco /home/loco/.ssh -R
  echo "SSH setup for loco"

  # Now can turn off password auth & root login.
  if [ ! -f /etc/ssh/sshd_config.orig ]
    then mv /etc/ssh/sshd_config  /etc/ssh/sshd_config.orig
  fi
  cat data/sshd_config > /etc/ssh/sshd_config
  echo "Updated sshd configuration"

  # Restart sshd and enable start on boot
  systemctl reload sshd
  systemctl enable sshd
  echo "Reloaded sshd"

  # The pk2-app should be owned by loco
  chown -R loco:loco /opt/pk2-app
fi

# git global env vars will be set for each user
cat data/git_global_env_vars > /etc/profile.d/git.sh
chmod 0644 /etc/profile.d/git.sh
