# -*- mode: ruby -*-
# vi: set ft=ruby :

include "jre7"

package { 'mysql-server' :
  ensure  => present,
  provider=> 'apt'
}

package { 'tomcat7' :
  ensure  => present,
  provider=> 'apt'
}
