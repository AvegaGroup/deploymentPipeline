# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define :ci do |cfg|
    cfg.vm.box = "precise64"

    cfg.vm.hostname = "devci1"

    # Jenkins
    cfg.vm.network :forwarded_port, guest: 8080, host: 18080

    # Artifactory
    cfg.vm.network :forwarded_port, guest: 8081, host: 18081

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    cfg.vm.network :private_network, ip: "192.168.10.10"

    # Provision puppet modules
    cfg.vm.provision :shell, :path => "puppet/install-modules.sh"

    # Puppet provisioning
    cfg.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "ci.pp"
    end

    # Provider-specific configuration for VirtualBox:
    cfg.vm.provider :virtualbox do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      # Fix for problem with NAT-DNS in fault version of VirtualBox at Ubuntu 12.10
      # see https://www.virtualbox.org/ticket/10864
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end

end
