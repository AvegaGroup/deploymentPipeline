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

node /prod/ inherits basenode {
  package { 'mysql-server' :
    ensure  => present,
    provider=> 'apt'
  }
  package { 'openjdk-7-jre' :
    ensure  => present,
    provider=> 'apt'
  }
  package { 'openjdk-6-jre-headless' :
    ensure  => purged,
    provider=> 'apt'
  } 
  
  package { 'tomcat7' :
    ensure  => present,
    provider=> 'apt'
  }
}

node /test/ inherits basenode {
  package { 'mysql-server' :
    ensure  => present,
    provider=> 'apt'
  }
  package { 'openjdk-7-jre' :
    ensure  => present,
    provider=> 'apt'
  }
  package { 'openjdk-6-jre-headless' :
    ensure  => purged,
    provider=> 'apt'
  }
  package { 'tomcat7' :
    ensure  => present,
    provider=> 'apt'
  }
}

import "puppetmaster.pp"

