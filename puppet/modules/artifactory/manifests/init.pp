# -*- mode: ruby -*-
# vi: set ft=ruby :

class artifactory {
    exec { 'download artifactory distro':
      command => '/usr/bin/wget http://sourceforge.net/projects/artifactory/files/artifactory/3.0.0/artifactory-3.0.0.zip/download -O /opt/artifactory-3.0.0.zip',
      creates => '/opt/artifactory-3.0.0.zip',
    }
    package { 'unzip':
      ensure => present,
      provider => 'apt'
    }
    exec { 'unpack artifactory distro':
      command => '/usr/bin/unzip -qo /opt/artifactory-3.0.0.zip -d /opt',
      creates => '/opt/artifactory-3.0.0',
      require => [Exec['download artifactory distro'], Package['unzip']]
    }
    exec { 'install artifactory':
      command => '/opt/artifactory-3.0.0/bin/installService.sh',
      creates => '/etc/init.d/artifactory',
      require => Exec['unpack artifactory distro']
    }
    service { 'artifactory':
      ensure => running,
      require => Exec['install artifactory']
    }
}
