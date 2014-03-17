#!/bin/bash -e

# An update will will be needed to be able to install most of the packages, somewhat kludgy
# to put it here, but letting everything in puppet to depend on a update execute would be worse.
sudo apt-get update

MODULE_DIR=/etc/puppet/modules
[ ! -d $MODULE_DIR ] && mkdir -p $MODULE_DIR

[ ! -d $MODULE_DIR/apt ] && puppet module install puppetlabs-apt --version 1.4.2
[ ! -d $MODULE_DIR/jenkins ] && puppet module install rtyler-jenkins --version 1.0.1
[ ! -d $MODULE_DIR/ntp ] && puppet module install puppetlabs-ntp --version 3.0.3
[ ! -d $MODULE_DIR/timezone ] && puppet module install saz-timezone --version 2.0.0
[ ! -d $MODULE_DIR/sudo ] && ppuppet module install saz-sudo --version 3.0.3


exit 0

