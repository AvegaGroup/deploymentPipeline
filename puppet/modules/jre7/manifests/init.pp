# -*- mode: ruby -*-
# vi: set ft=ruby :

class jre7 {
  package { 'openjdk-7-jre' :
    ensure  => present,
    provider=> 'apt'
  }
  package { 'openjdk-6-jre-headless' :
    ensure  => purged,
    provider=> 'apt'
  }
}
