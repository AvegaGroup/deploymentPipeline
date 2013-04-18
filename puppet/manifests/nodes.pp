node puppetmaster {
  service { 'puppet':
    ensure => 'running',
    enable => 'true',
  }
  service { 'puppetmaster':
    ensure => 'running',
    enable => 'true',
  }
}