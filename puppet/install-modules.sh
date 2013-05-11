#!/bin/bash -e

MODULE_DIR=/etc/puppet/modules
[ ! -d $MODULE_DIR ] && mkdir -p $MODULE_DIR

[ ! -d $MODULE_DIR/jenkins ] && puppet module install rtyler/jenkins

exit 0

