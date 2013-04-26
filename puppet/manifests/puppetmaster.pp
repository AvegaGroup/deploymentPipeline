node puppetmaster inherits basenode {

# Razor:
# http://forge.puppetlabs.com/puppetlabs/razor
# Require:
# puppet module install puppetlabs-razor
# Shouldn't be needed.
# puppet apply /etc/puppet/modules/razor/tests/init.pp --verbose
# Change according to https://github.com/puppetlabs/puppetlabs-razor/commit/f69c03d localy with v0.6.1
  include razor

 

service { 'puppetmaster':
    ensure => 'running',
    enable => 'true',
}

  # Firewall https://forge.puppetlabs.com/puppetlabs/firewall
  firewall { '100 Dont nat to client network':
     chain    => 'POSTROUTING',
     action     => 'accept',
     proto    => 'all',
     destination => '192.168.155.0/24',
     source   => '192.168.128.0/22',
     table    => 'nat',
  }
 
  firewall { '105 Nat everything else':
    chain    => 'POSTROUTING',
    jump     => 'MASQUERADE',
    proto    => 'all',
    outiface => "eth0",
    source   => '192.168.17.0/24',
    table    => 'nat',
  }
  # And now forward packages: 
    file { "/etc/sysctl.d/60-ip_forward":
      content => "net.ipv4.ip_forward = 1\n",
      ensure  => present,
    }
    
 
# Razor:
# http://forge.puppetlabs.com/puppetlabs/razor
# Require:
# puppet module install puppetlabs-razor
# Shouldn't be needed.
# puppet apply /etc/puppet/modules/razor/tests/init.pp --verbose
# Change according to https://github.com/puppetlabs/puppetlabs-razor/commit/f69c03d localy with v0.6.1
#  include razor

# Require
# puppet module install saz-dnsmasq
  dnsmasq::conf { '1-razor':
    ensure  => present,
    content => "dhcp-boot=tag:!client,pxelinux.0\ndomain=dp.sennerholm.net\nexpand-hosts\nexcept-interface=eth0",
  }

  dnsmasq::conf { 'eth2-128-client':
    ensure  => present,
    content => "dhcp-range=interface:eth2,set:client,192.168.128.10,192.168.128.99,12h\ndhcp-option=tag:ci,3,192.168.128.1,\ndhcp-option=tag:ci,6,192.168.128.1\n",
  }


  dnsmasq::conf { 'eth2-129-ci':
    ensure  => present,
    content => "dhcp-range=interface:eth3,set:ci,192.168.129.10,192.168.129.99,12h\ndhcp-option=tag:ci,3,192.168.129.1,\ndhcp-option=tag:ci,6,192.168.129.1\n",
  }

  dnsmasq::conf { 'eth3-130-test':
    ensure  => present,
    content => "dhcp-range=interface:eth3,set:test,192.168.130.10,192.168.130.99,12h\ndhcp-option=tag:test,3,192.168.130.1,\ndhcp-option=tag:test,6,192.168.130.1\n",

  }

  dnsmasq::conf { 'eth4-131-prod':
    ensure  => present,
    content => "dhcp-range=interface:eth4,set:prod,192.168.131.10,192.168.131.99,12h\ndhcp-option=tag:prod,3,192.168.131.1,\ndhcp-option=tag:prod,6,192.168.131.1\n",
  }



  rz_image { 'precise_image':
    ensure  => 'present',
    type    => 'os',
    version => '12.04',
    source  => '/root/ubuntu-12.04.2-server-amd64.iso',
  }

# Temporary
 rz_model { 'cdtest':
   ensure      => present,
   description => 'Test vm for Continius Deployment lab',
   image       => 'precise_image',
   metadata    => {
     'domainname'      => 'dp.sennerholm.net',
     'hostname_prefix' => 'test',
     'rootpassword'    => 'test1234',
   },
   template    => 'ubuntu_precise',
 }

rz_tag { 'oncinetwork':
  ensure   => 'present',
  tag_label   => 'oncinetwork',
  tag_matcher => [
    { 'key'     => 'network_eth0',
      'compare' => 'equal',
      'value'   => '192.168.129.0',
      'inverse' => false, }
  ],
}
rz_tag { 'ontestnetwork':
  ensure   => 'present',
  tag_label   => 'ontestnetwork',
  tag_matcher => [
    { 'key'     => 'network_eth0',
      'compare' => 'equal',
      'value'   => '192.168.130.0',
      'inverse' => false, }
  ],
}

rz_tag { 'onprodnetwork':
  ensure   => 'present',
  tag_label   => 'onprodnetwork',
  tag_matcher => [
    { 'key'     => 'network_eth0',
      'compare' => 'equal',
      'value'   => '192.168.131.0',
      'inverse' => false, }
  ],
}

rz_tag { 'virtual':
  ensure   => 'absent',
  tag_label   => 'virtual',
  tag_matcher => [
    { 'key'     => 'is_virtual',
      'compare' => 'equal',
      'value'   => 'true',
      'inverse' => false, }
  ],
}

rz_policy { 'precise_policy':
  ensure   => 'absent',
  broker   => 'none',
  model    => 'precise_model',
  enabled  => 'true',
  tags     => ['virtual'],
  template => 'linux_deploy',
  maximum  => 1,
}
# End of Temp	
rz_broker { 'puppetmaster':
  plugin  => 'puppet',
  metadata => {
    server  => 'puppetmaster.hem.sennerholm.net',
  }

}
}