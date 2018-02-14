sudo yum groupinstall 'Development Tools'

cd ~
git clone https://github.com/dpneumo/pk2.git

cd pk2
bundle install


# https://yarnpkg.com/en/docs/install (Centos7)
sudo yum install -y gcc-c++ make
sudo wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
curl --silent --location https://rpm.nodesource.com/setup_6.x | sudo bash -
sudo yum install -y yarn
