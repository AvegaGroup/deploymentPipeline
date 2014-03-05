#!/bin/bash -e

# Ensure that we have the correct host file for all hosts
if [ /vagrant/vagrant/hosts -nt /etc/hosts  ]; 
then  
    cp /vagrant/vagrant/hosts /etc/hosts ;
    chown root:root /etc/hosts; 
fi


# An update will will be needed to be able to install most of the packages, somewhat kludgy
# to put it here, but letting everything in puppet to depend on a update execute would be worse.
sudo apt-get update

MODULE_DIR=/etc/puppet/modules
[ ! -d $MODULE_DIR ] && mkdir -p $MODULE_DIR

[ ! -d $MODULE_DIR/apt ] && puppet module install puppetlabs/apt
[ ! -d $MODULE_DIR/jenkins ] && puppet module install rtyler/jenkins --version 0.3.1
[ ! -d $MODULE_DIR/ntp ] && puppet module install puppetlabs/ntp 
[ ! -d $MODULE_DIR/timezone ] && puppet module install saz/timezone
[ ! -d $MODULE_DIR/sudo ] && puppet module install saz/sudo
[ ! -d $MODULE_DIR/mysql ] && puppet module install puppetlabs/mysql

exit 0

