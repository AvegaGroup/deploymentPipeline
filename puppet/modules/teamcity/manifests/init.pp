# -*- mode: ruby -*-
# vi: set ft=ruby :

class teamcity {

    file { '/opt/TeamCity-8.0.6.tar.gz' :
         mode   => '0755',
         owner  => 'vagrant',
         group  => 'vagrant',
         source => 'puppet:///modules/teamcity/TeamCity-8.0.6.tar.gz'
    }

    file { '/opt/installtc.sh' :
        mode   => '0755',
        owner  => 'vagrant',
        group  => 'vagrant',
        source => 'puppet:///modules/teamcity/installteamcity.sh'
    }

    file { '/opt/TeamCity':
        ensure => directory,
        mode   => '0755',
        owner  => 'vagrant',
        group  => 'vagrant',
        recurse => 'true',
        before  => File["/opt/TeamCity/.BuildServer"]
    }

    file { '/etc/init.d/teamcity':
        mode   => '0755',
        owner  => 'vagrant',
        group  => 'vagrant',
        source => 'puppet:///modules/teamcity/teamcity',
    }

    file { '/opt/TeamCity/.BuildServer':
         ensure => directory,
         mode   => '0755',
         owner  => 'vagrant',
         group  => 'vagrant',
         recurse => 'true',
         source => 'puppet:///modules/teamcity/BuildServer',
         require => File['/opt/TeamCity']
    }


   exec { 'install and start tc server':
        command => 'sh installtc.sh',
        cwd     => '/opt',
        path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        user    => "vagrant",
        require => [File['/opt/TeamCity-8.0.6.tar.gz'], File['/opt/TeamCity'], File['/etc/init.d/teamcity'], File['/opt/TeamCity/.BuildServer']],
    }

    service { 'teamcity':
        ensure => running,
        require => Exec['install and start tc server']
    }
}
