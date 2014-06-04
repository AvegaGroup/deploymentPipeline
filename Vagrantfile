# -*- mode: ruby -*-
# vi: set ft=ruby :

$script_lb = <<SCRIPT
    echo Provisioning VM...
    echo Installing dependencies...
    apt-get update
    apt-get -qy install haproxy=1.4.18-0ubuntu1.2
    echo Configuring haproxy...
    echo                                                        >> /etc/haproxy/haproxy.cfg
    echo "frontend http-in"                                     >> /etc/haproxy/haproxy.cfg
    echo "        bind *:9000"                                  >> /etc/haproxy/haproxy.cfg
    echo "        default_backend servers"                      >> /etc/haproxy/haproxy.cfg
    echo                                                        >> /etc/haproxy/haproxy.cfg
    echo "backend servers"                                      >> /etc/haproxy/haproxy.cfg
    echo "        stats enable"                                 >> /etc/haproxy/haproxy.cfg
    echo "        retries 3"                                    >> /etc/haproxy/haproxy.cfg
    echo "        option redispatch"                            >> /etc/haproxy/haproxy.cfg
    echo "        option httpchk"                               >> /etc/haproxy/haproxy.cfg
    echo "        option forwardfor"                            >> /etc/haproxy/haproxy.cfg
    echo "        option http-server-close"                     >> /etc/haproxy/haproxy.cfg
    echo "        server prod 10.0.2.2:18001 check inter 1000"  >> /etc/haproxy/haproxy.cfg
    echo "        server prod2 10.0.2.2:18002 check inter 1000" >> /etc/haproxy/haproxy.cfg
    echo "ENABLED=1" > /etc/default/haproxy
    service haproxy restart
    echo Done.
SCRIPT

$curl_unzip = <<SCRIPT
    echo "Install curl and unzip"
    sudo apt-get -y install curl=7.22.0-3ubuntu4.7
    sudo apt-get -y install unzip=6.0-4ubuntu2
SCRIPT




Vagrant.configure("2") do |config|
  # Supports local cache, don't wast bandwitdh
  # vagrant plugin install vagrant-cachier
  # https://github.com/fgrehm/vagrant-cachier 
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"  

  # JENKINS Machine
  config.vm.define :jenkins1 do |cfg|
    cfg.vm.box = "precise64"

    cfg.vm.hostname = "jenkins1"

    # Jenkins
    cfg.vm.network :forwarded_port, guest: 8080, host: 18080

    # Artifactory
    cfg.vm.network :forwarded_port, guest: 8081, host: 18081

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    cfg.vm.network :private_network, ip: "192.168.129.100"

    # Provision puppet modules
    cfg.vm.provision :shell, :path => "vagrant/install-modules.sh"
    #Ensure CI environment knows of test and prod instances
    cfg.vm.provision :shell, :inline => "sudo cp -f  /vagrant/vagrant/hosts /etc/hosts"
    cfg.vm.provision :shell, :inline => $curl_unzip

    # Ugly workaround to handle changed behavior of vagrant 1.4.1 and future
    # More information in: https://github.com/mitchellh/vagrant/pull/2677
    config.vm.synced_folder './puppet/modules', '/tmp/vagrant-puppet-1/modules-0'
    # Need to let jenkins write to this folder, using owner/group is depending on having that user in the host os.
    config.vm.synced_folder './jenkins', '/var/lib/jenkins', mount_options: ["dmode=777,fmode=666"]

    # Puppet provisioning
    cfg.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
#      puppet.module_path = "puppet/modules"
      puppet.options        = '--modulepath "/etc/puppet/modules:/tmp/vagrant-puppet-1/modules-0"'
      puppet.manifest_file = "site.pp"
    end

    # Provider-specific configuration for VirtualBox:
    cfg.vm.provider :virtualbox do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      # Fix for problem with NAT-DNS in fault version of VirtualBox at Ubuntu 12.10
      # see https://www.virtualbox.org/ticket/10864
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end
  # TEST machine
  config.vm.define :test do |cfg|
    cfg.vm.box = "precise64"

    cfg.vm.hostname = "test1"

    # Tomcat
    cfg.vm.network :forwarded_port, guest: 8080, host: 18090

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    cfg.vm.network :private_network, ip: "192.168.130.100"

    # Provision puppet modules
    cfg.vm.provision :shell, :path => "vagrant/install-modules.sh"
    cfg.vm.provision :shell, :inline => "sudo cp -f  /vagrant/vagrant/test/hosts /etc/hosts"
    cfg.vm.provision :shell, :inline => $curl_unzip


    # Ugly workaround to handle changed behavior of vagrant 1.4.1 and future
    # More information in: https://github.com/mitchellh/vagrant/pull/2677
    config.vm.synced_folder './puppet/modules', '/tmp/vagrant-puppet-1/modules-0'
    # Puppet provisioning
    cfg.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
 #     puppet.module_path = "puppet/modules"
      puppet.options        = '--modulepath "/etc/puppet/modules:/tmp/vagrant-puppet-1/modules-0"'
      puppet.manifest_file = "site.pp"
    end

    # Provider-specific configuration for VirtualBox:
    cfg.vm.provider :virtualbox do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "512"]
      # Fix for problem with NAT-DNS in fault version of VirtualBox at Ubuntu 12.10
      # see https://www.virtualbox.org/ticket/10864
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end

 config.vm.define :prodlb do |cfg|
        cfg.vm.box = "precise64"
        cfg.vm.hostname = "prodlb"

        cfg.vm.network :private_network, ip: "192.168.131.100"
        cfg.vm.provision :shell, :inline => "sudo cp -f  /vagrant/vagrant/prod/hosts /etc/hosts"

        cfg.vm.provision :shell, :inline => $script_lb
        cfg.vm.network "forwarded_port", guest: 9000, host: 9000
        cfg.vm.provider "virtualbox" do |vm|
          vm.customize [
                     'modifyvm', :id,
                     '--memory', '512'
                 ]
        end
    end

 config.vm.define :prod1 do |cfg|
    cfg.vm.box = "precise64"

    cfg.vm.hostname = "prod1"

    # Tomcat
    cfg.vm.network :forwarded_port, guest: 8080, host: 18001

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    cfg.vm.network :private_network, ip: "192.168.131.101"
    cfg.vm.provision :shell, :inline => "sudo cp -f  /vagrant/vagrant/prod/hosts /etc/hosts"

    # Provision puppet modules
    cfg.vm.provision :shell, :path => "vagrant/install-modules.sh"
    cfg.vm.provision :shell, :inline => $curl_unzip

   # Ugly workaround to handle changed behavior of vagrant 1.4.1 and future
    # More information in: https://github.com/mitchellh/vagrant/pull/2677
    config.vm.synced_folder './puppet/modules', '/tmp/vagrant-puppet-1/modules-0'
    # Puppet provisioning
    cfg.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
#      puppet.module_path = "puppet/modules"
      puppet.options        = '--modulepath "/etc/puppet/modules:/tmp/vagrant-puppet-1/modules-0"'
      puppet.manifest_file = "site.pp"
    end

    #stop and start Mysql to allow incoming network connections to hostname db
    cfg.vm.provision :shell, :inline => "sudo service mysql stop"
    cfg.vm.provision :shell, :inline => "sudo service mysql start"

    # Provider-specific configuration for VirtualBox:
    cfg.vm.provider :virtualbox do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "512"]
      # Fix for problem with NAT-DNS in fault version of VirtualBox at Ubuntu 12.10
      # see https://www.virtualbox.org/ticket/10864
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end

  config.vm.define :prod2 do |cfg|
    cfg.vm.box = "precise64"

    cfg.vm.hostname = "prod2"

    # Tomcat
    cfg.vm.network :forwarded_port, guest: 8080, host: 18002

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    cfg.vm.network :private_network, ip: "192.168.131.102"
    cfg.vm.provision :shell, :inline => "sudo cp -f  /vagrant/vagrant/prod/hosts /etc/hosts"

    # Provision puppet modules
    cfg.vm.provision :shell, :path => "vagrant/install-modules.sh"
    cfg.vm.provision :shell, :inline => $curl_unzip

   # Ugly workaround to handle changed behavior of vagrant 1.4.1 and future
    # More information in: https://github.com/mitchellh/vagrant/pull/2677
    config.vm.synced_folder './puppet/modules', '/tmp/vagrant-puppet-1/modules-0'
    # Puppet provisioning
    cfg.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
      #puppet.module_path = "puppet/modules"
      puppet.options        = '--modulepath "/etc/puppet/modules:/tmp/vagrant-puppet-1/modules-0"'
      puppet.manifest_file = "site.pp"
    end

    # Provider-specific configuration for VirtualBox:
    cfg.vm.provider :virtualbox do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "512"]
      # Fix for problem with NAT-DNS in fault version of VirtualBox at Ubuntu 12.10
      # see https://www.virtualbox.org/ticket/10864
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end

end
