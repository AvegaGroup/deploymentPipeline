node basenode {
  import "users.pp"

  class { '::ntp':
    servers => [ 'ntp1.sp.se', 'ntp2.sp.se' ],
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

node /ci/ inherits basenode {
  include "jdk7"
  include "maven3"
  include "jenkins"
  include "artifactory"
  include "apt"



  package { 'git':
    ensure   => present,
    provider => 'apt',
  }

 class { '::mysql::server':
    root_password  => 'mysecret_ci',
  }

  mysql::db { 'petclinic':
    user     => 'pc',
    password => 'mac',
    host     => 'localhost',
    grant    => ['all'],
  }

  apt::ppa { 'ppa:chris-lea/fabric': }
  apt::ppa { 'ppa:chris-lea/python-crypto': }
  apt::ppa { 'ppa:chris-lea/python-paramiko': }
  package { 'fabric':
    ensure => present,
    provider => 'apt',
    require => Apt::Ppa['ppa:chris-lea/fabric']
  }

  user { "jenkins":
    ensure     => present,
    home       => '/var/lib/jenkins'
  }

  # Add new plugins below!
  # Maybe not handling dependencies
  jenkins::plugin {
    "git-client": ;
    "parameterized-trigger": ;
    "token-macro": ;
    "ssh-credentials": ;
    "scm-api": ;
    "credentials": ;
    "multiple-scms": ;
    "git": ;
    "github-api": ;
    "github": ;
    "artifactory": ;
    "jquery": ;
    "jquery-ui": ;
    "dashboard-view": ;
    "build-pipeline-plugin": ;
    "promoted-builds": ;
    "copyartifact": ;
    "delivery-pipeline-plugin": ;
  }
   
  
# Directory for ssh conf
  file { "/root/.ssh" :
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 700,
  }
# File for ssh 
  file { "/root/.ssh/config" :
    ensure => "present",
    content=> "Host *\nStrictHostKeyChecking no",
  }
  file { "/root/.ssh/id_rsa" :
    ensure => "present",
    owner  => "root",
    group  => "root",
    mode   => 700,
    content=> "-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEA3P4zE5x26iUxXtJaARdltkc3XfSmgDUjfdR2e3bqkZK1XS2/\n66Q3nXn5WsWG1KPONz5ZJ4I0R6+KfctIpCqnMVdYUD+1yk9IffuCNIienRY/nrHC\nOU5o1ecJ7T6oBlZTJRHlTSl/nw/34lEjb1mAyUWQZ0UM43ijZdd6WKLCK7hNUWzv\nAfwnv9TZCjz9ogNwQ/fJmGsykgEUALBAjFSdXeUFgHomyaI1l7E9bai7LiNTsAEi\nBEMv9veANVCmyOnk3JTePbhc13jy7drFyvcsSIFjhcimmZFHwfiRggNW9sleSgXc\nwCYHvcxPqOvf6WFKVtLwmBi3QoWYbtCsoj07kwIDAQABAoIBABVH6VU/IPhlQn7W\nFNK8FRBbhUpn78yy0UshtZMoHWiNTye86xlfA/gHMer60IQTjh0lxOIYGL66ecSp\nWcJtVRJcTeXUbMYhomJ3YM98RIHuDYxTo9du5IuMpxkQio+pqnIMah9nGqIPoJhL\npfToEo3PRBudu6MAEAQTnvWAHuCkvgTsKE8z0mvw+sT+pEC2YNUNJPRvgWvag+v+\nZEeqprhRM8q8G3AOntUtwV8+ofmhAzqSgflkdxHljMSHWY6QO63kBzoGueQL/UZx\nqwXBM48kdoLwq8kXf+Vue3AIyaKI5k8Ogu8VQN32gTHK8ol+naSBzECaF2T8IW2p\nyJ3cGKkCgYEA8SslchdpCqLpAc/dFA0NhNU7e6m7gith1viP70eFrvC1zqH7ydOI\nAFWU74mwk8QZButlApMDtglQAMUdO3Lykg5M9mm2Oif5LoFQOJkXCPnZQSzVQMj9\nx/wgF43c0Dd2/bdUCb1wgUD9HbDjiMp9pCSYeG0rst5GGfhxjhYcJtcCgYEA6pVq\n7nsuKjmLEQhsb8tKeUSMw1eGmntP8diIJoMJU/WvjgDbASh7CfwIUwrJ+6zuUQDm\nFu2PIBrRSt0xGokgPidUuBT+cpDBoVvpiKJui7SNicUBkNKC/XF0+lvSu/6zqAIX\nRoNUieLagZWJhgkPQAKg/BDeqFk73fVo4kiaBaUCgYEAsgSfR3BwYSGPzX6aOkrI\nR9z+Y3IOry9GsWAZHw80ZsXX7gczzO8P3O9PWOHSLcD6mFj53sSWYLDPFUJrKY7X\n72gO93Vgxdzr2qApjx2yGzYSYEGvyHqUmiJJrhlRfYDznKTOq8HiYgaO0HPaAQc3\nZwp8Yah0MTxRkqoJaFB5x1ECgYEAlMRxbhBcdJbNpN2stzE7Z7CbfH6TdIDjcEKc\nBaBwV/ilfu739MIRVYGqXc+nzJ4c/O4O/VdmvzuCo3GnZGa2NfSHe76Ep285/PTn\nI6mvZZX5dPelSIzYWZaMUwHMoUCj+tZooGVFRbTCUg/diU1RiIyiP3kLW8RLfTXX\ncDoOw6kCgYEAm1xdc8Ry9O/Lq//0yCNaNmQiDX0vExvsT/7iCRQ1ps/3nTN2pMdB\ngHjOE1reGA8X62QjJ6eW2o/joX9VZS770CFFcjqX6zzBIQTAtdRTHLh6kKxrbU6U\n+a/SV0VQiOn9DiIYYYfPDFF4JERb1ClOFGEZ++41opeFkp27EahPvVc=\n-----END RSA PRIVATE KEY-----",

  }


}

node /go/ inherits basenode {
  include "jdk7"
  include "maven3"
  include "apt"

  package { 'git':
    ensure   => present,
    provider => 'apt',
  }

  class { '::mysql::server':
      root_password  => 'mysecret_ci',
    }

    mysql::db { 'petclinic':
      user     => 'pc',
      password => 'mac',
      host     => 'localhost',
      grant    => ['all'],
    }
}

node /test/ inherits basenode {
include "jre7"

    class { '::mysql::server':
        root_password  => 'mysecret_ci',
    }

    mysql::db { 'petclinic':
        user     => 'pc',
        password => 'mac',
        host     => 'localhost',
        grant    => ['all'],
    }

    package { 'tomcat7' :
        ensure  => present,
        provider=> 'apt'
    }

    ssh_authorized_key { 'cisshkey' :
        ensure  => present,
        key     => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDc/jMTnHbqJTFe0loBF2W2Rzdd9KaANSN91HZ7duqRkrVdLb/rpDedeflaxYbUo843PlkngjRHr4p9y0ikKqcxV1hQP7XKT0h9+4I0iJ6dFj+escI5TmjV5wntPqgGVlMlEeVNKX+fD/fiUSNvWYDJRZBnRQzjeKNl13pYosIruE1RbO8B/Ce/1NkKPP2iA3BD98mYazKSARQAsECMVJ1d5QWAeibJojWXsT1tqLsuI1OwASIEQy/294A1UKbI6eTclN49uFzXePLt2sXK9yxIgWOFyKaZkUfB+JGCA1b2yV5KBdzAJge9zE+o69/pYUpW0vCYGLdChZhu0KyiPTuT",
        name    => "root@CI",
        type    => "ssh-rsa",
        user    => "root",
    }

}

node /prod/ inherits basenode {
include "jre7"

    class { '::mysql::server':
        root_password  => 'mysecret_ci',
    }

    mysql::db { 'petclinic':
        user     => 'pc',
        password => 'mac',
        host     => 'localhost',
        grant    => ['all'],
    }

    package { 'tomcat7' :
        ensure  => present,
        provider=> 'apt'
    }

    ssh_authorized_key { 'cisshkey' :
        ensure  => present,
        key     => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDc/jMTnHbqJTFe0loBF2W2Rzdd9KaANSN91HZ7duqRkrVdLb/rpDedeflaxYbUo843PlkngjRHr4p9y0ikKqcxV1hQP7XKT0h9+4I0iJ6dFj+escI5TmjV5wntPqgGVlMlEeVNKX+fD/fiUSNvWYDJRZBnRQzjeKNl13pYosIruE1RbO8B/Ce/1NkKPP2iA3BD98mYazKSARQAsECMVJ1d5QWAeibJojWXsT1tqLsuI1OwASIEQy/294A1UKbI6eTclN49uFzXePLt2sXK9yxIgWOFyKaZkUfB+JGCA1b2yV5KBdzAJge9zE+o69/pYUpW0vCYGLdChZhu0KyiPTuT",
        name    => "root@CI",
        type    => "ssh-rsa",
        user    => "root",
    }
}

import "puppetmaster.pp"

