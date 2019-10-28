#!/bin/bash

#sudo yum update -y && sudo yum upgrade -y

mkdir /home/vagrant/.ssh

chmod 700 /home/vagrant/.ssh

cat /vagrant/vagrant.pub > /home/vagrant/.ssh/authorized_keys

sudo chmod 600 /home/vagrant/.ssh/authorized_keys

cp /vagrant/vagrant /home/vagrant/.ssh/vagrant

sudo chown vagrant:vagrant /home/vagrant/.ssh/vagrant
sudo echo "" > /etc/ssh/sshd_config
sudo echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

sudo echo "Host *" >> /home/vagrant/.ssh/config
sudo echo " StrictHostKeyChecking no" >> /home/vagrant/.ssh/config
sudo echo " UserKnownHostsFile=/dev/null" >> /home/vagrant/.ssh/config