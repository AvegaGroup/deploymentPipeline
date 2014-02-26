# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Supports local cache, don't wast bandwitdh
  # vagrant plugin install vagrant-cachier
  # https://github.com/fgrehm/vagrant-cachier 
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"  

  # CI Machine
  config.vm.define :ci do |cfg|
    cfg.vm.box = "precise64"

    cfg.vm.hostname = "ci1"

    # Jenkins
    cfg.vm.network :forwarded_port, guest: 8080, host: 18080

    # Artifactory
    cfg.vm.network :forwarded_port, guest: 8081, host: 18081

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    cfg.vm.network :private_network, ip: "192.168.129.110"

    # Provision puppet modules
    cfg.vm.provision :shell, :path => "vagrant/install-modules.sh"
    #Ensure CI environment knows of test and prod instances
    cfg.vm.provision :shell, :inline => "sudo ln -fs /vagrant/vagrant/hosts /etc/hosts"
     #Curl seems to not be installed. Hacked
    cfg.vm.provision :shell, :inline => "sudo apt-get -y install curl"

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
    cfg.vm.network :private_network, ip: "192.168.130.72"

    # Provision puppet modules
    cfg.vm.provision :shell, :path => "vagrant/install-modules.sh"
     #Unzip & Curl seems to not be installed. Hacked
    cfg.vm.provision :shell, :inline => "sudo apt-get -y install unzip"
    cfg.vm.provision :shell, :inline => "sudo apt-get -y install curl"


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

  config.vm.define :prod do |cfg|
    cfg.vm.box = "precise64"

    cfg.vm.hostname = "prod1"

    # Tomcat
    cfg.vm.network :forwarded_port, guest: 8080, host: 18100

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    cfg.vm.network :private_network, ip: "192.168.131.74"

    # Provision puppet modules
    cfg.vm.provision :shell, :path => "vagrant/install-modules.sh"
    #Unzip & Curl seems to not be installed. Hacked
    cfg.vm.provision :shell, :inline => "sudo apt-get -y install unzip"
    cfg.vm.provision :shell, :inline => "sudo apt-get -y install curl"

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
