#!/bin/bash -e

# Set up a virtual development environment on Ubuntu Desktop

# Install Virtualbox
sudo apt-get install -y virtualbox

# Install Vagrant
VAGRANT_PKG_URL="http://files.vagrantup.com/packages/7e400d00a3c5a0fdf2809c8b5001a035415a607b/vagrant_1.2.2_x86_64.deb"
VAGRANT_VERSION="1.2.2"
VAGRANT_PKG="/tmp/vagrant_${VAGRANT_VERSION}_x86_64.deb"

if [ $(dpkg-query -Wf='${db:Status-abbrev}' vagrant) != "ii" -o $(dpkg-query -Wf='${Version}' vagrant) != $VAGRANT_VERSION ]; then

    [ ! -f $VAGRANT_PKG ] && wget --output-document=$VAGRANT_PKG $VAGRANT_PKG_URL
    sudo dpkg --install $VAGRANT_PKG
fi

# Add Ubuntu box to Vagrant
BOX_VERSION="precise64"
BOX_URL="http://files.vagrantup.com/${BOX_VERSION}.box"
if ! $(vagrant box list | grep -q $BOX_VERSION); then
    vagrant box add $BOX_VERSION $BOX_URL
fi
