node basenode {
  import "users.pp"
  class { ntp:
    ensure     => running,
    servers    => [ 'ntp1.sp.se iburst',
                    'ntp2.sp.se iburst', ],
    autoupdate => true,
  }

  class { 'timezone':
    timezone => 'Europe/Stockholm',
    autoupgrade => true,
  }
  class { 'sudo':
    config_file_replace => false,
  }

}

node default inherits basenode {    
}



node puppetmaster inherits basenode {

# Razor:
# http://forge.puppetlabs.com/puppetlabs/razor
# Require:
# puppet module install puppetlabs-razor
# Shouldn't be needed.
# puppet apply /etc/puppet/modules/razor/tests/init.pp --verbose
# Change according to https://github.com/puppetlabs/puppetlabs-razor/commit/f69c03d localy with v0.6.1
  include razor

  import "puppetmaster.pp"
 
}
