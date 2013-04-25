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


import "puppetmaster.pp"

