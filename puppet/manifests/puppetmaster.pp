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
  dnsmasq::conf { '129-ci':
    ensure  => present,
    content => "dhcp-range=192.168.129.10,192.168.129.99,12h\ndhcp-boot=pxelinux.0\ndhcp-option=3,192.168.129.1\ndhcp-option=6,192.168.129.1\ndomain=dp.sennerholm.net\nexpand-hosts\ndhcp-host=puppetmaster,192.168.129.1\interface=eth2\n",
  }
  dnsmasq::conf { '130-test':
    ensure  => present,
    content => "dhcp-range=192.168.130.10,192.168.130.99,12h\ndhcp-boot=pxelinux.0\ndhcp-option=3,192.168.130.1\ndhcp-option=6,192.168.130.1\ndomain=dp.sennerholm.net\nexpand-hosts\ndhcp-host=puppetmaster,192.168.130.1\interface=eth2\n",

  }

  dnsmasq::conf { '131-prod':
    ensure  => present,
    content => "dhcp-range=192.168.131.10,192.168.131.99,12h\ndhcp-boot=pxelinux.0\ndhcp-option=3,192.168.131.1\ndhcp-option=6,192.168.131.1\ndomain=dp.sennerholm.net\nexpand-hosts\ndhcp-host=puppetmaster,192.168.131.1\interface=eth2\n",

  }



  rz_image { 'precise_image':
    ensure  => 'present',
    type    => 'os',
    version => '12.04',
    source  => '/root/ubuntu-12.04.2-server-amd64.iso',
  }
 rz_model { 'precise_model':
   ensure      => present,
   description => 'Ubuntu Precise Model',
   image       => 'precise_image',
   metadata    => {
     'domainname'      => 'puppetlabs.lan',
     'hostname_prefix' => 'openstack',
     'rootpassword'    => 'puppet',
   },
   template    => 'ubuntu_precise',
 }

rz_tag { 'virtual':
  tag_label   => 'virtual',
  tag_matcher => [
    { 'key'     => 'is_virtual',
      'compare' => 'equal',
      'value'   => 'true',
      'inverse' => false, }
  ],
}

rz_policy { 'precise_policy':
  ensure   => 'present',
  broker   => 'none',
  model    => 'precise_model',
  enabled  => 'true',
  tags     => ['virtual'],
  template => 'linux_deploy',
  maximum  => 1,
}
}