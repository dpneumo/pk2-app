
# On appserv-prod
sudo mkdir /etc/symmetric-encryption
sudo chown loco:loco /etc/symmetric-encryption
sudo chmod 750 /etc/symmetric-encryption

# On laptop VBox VM
sudo scp /etc/symmetric-encryption/pk2* loco@<appserv-prod ip>:/etc/symmetric-encryption

# On appserv-prod
sudo chown loco:loco /etc/symmetric-encryption/*
sudo chmod 400 /etc/symmetric-encryption/*
