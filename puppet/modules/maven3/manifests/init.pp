# -*- mode: ruby -*-
# vi: set ft=ruby :

class maven3 {
    include "apt"

    apt::ppa { 'ppa:natecarlson/maven3': }
    package { 'maven3':
      ensure => present,
      provider => 'apt',
      before=> File["/usr/share/maven3/conf/settings.xml"],
      require => Apt::Ppa['ppa:natecarlson/maven3']
    }
# copy a remote file to /etc/sudoers
    file { "/usr/share/maven3/conf/settings.xml":
      mode => 644,
      owner => vagrant,
      group => vagrant,
      source => "puppet:///modules/maven3/settings.xml"
    }
}
