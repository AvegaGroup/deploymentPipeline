# -*- mode: ruby -*-
# vi: set ft=ruby :

class jdk7 {
  package { 'openjdk-7-jdk' :
    ensure  => present,
    provider=> 'apt'
  }
  package { 'openjdk-6-jre-headless' :
    ensure  => purged,
    provider=> 'apt'
  }
}
