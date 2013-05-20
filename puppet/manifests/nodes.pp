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
include "jre7"

package { 'mysql-server' :
  ensure  => present,
  provider=> 'apt'
}

package { 'tomcat7' :
  ensure  => present,
  provider=> 'apt'
}
}

node /ci/ inherits basenode {
  include "jdk7"
  include "maven3"
  include "jenkins"
  include "artifactory"
  include "apt"  

  apt::ppa { 'ppa:chris-lea/fabric': }
  apt::ppa { 'ppa:chris-lea/python-crypto': }
  apt::ppa { 'ppa:chris-lea/python-paramiko': }
  package { 'fabric':
    ensure => present,
    provider => 'apt',
    require => Apt::Ppa['ppa:chris-lea/fabric']
  }


jenkins::plugin {
  "git": ;
  "artifactory": ;
  "build-pipeline-plugin": ;
  "scm-sync-configuration": ;
}

}
node /test/ inherits basenode {
include "jre7"

package { 'mysql-server' :
  ensure  => present,
  provider=> 'apt'
}

package { 'tomcat7' :
  ensure  => present,
  provider=> 'apt'
}

}

import "puppetmaster.pp"

