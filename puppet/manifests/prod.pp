# -*- mode: ruby -*-
# vi: set ft=ruby :

include "jre7"

package { 'tomcat7' :
  ensure  => present,
  provider=> 'apt'
}
