# -*- mode: ruby -*-
# vi: set ft=ruby :

class maven3 {
    include "apt"

    apt::ppa { 'ppa:natecarlson/maven3': }
    package { 'maven3':
      ensure => present,
      provider => 'apt',
      require => Apt::Ppa['ppa:natecarlson/maven3']
    }
}
