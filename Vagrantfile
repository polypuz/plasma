# -*- mode: ruby -*-
# vi: set ft=ruby :

# General project config
# ##############################################################################
    # IP Address for the host only network, change it to anything you like
    # but please keep it within the IPv4 private network range
    ip_address = "127.0.0.2"

    # The project name is base for directories, hostname and alike
    project_name = "mirkots"


# Vagrant configuration
# ##############################################################################
Vagrant.configure(2) do |config|
    # Set VM Box
    config.vm.box = "ubuntu/trusty64"

    # Set RAM size to 1GB
    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
    end

    # Run provisioner
    config.vm.provision :shell, :path => "vagrant/Vagrant-provision", privileged: false
    config.vm.provision :shell, :path => "vagrant/Vagrant-prepare-tfs", privileged: false

    # Use hostonly network with a static IP Address and enable
    # hostmanager so we can have a custom domain for the server
    # by modifying the host machines hosts file
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.vm.define project_name do |node|
        node.vm.hostname = project_name + ".local"
        node.vm.network :private_network, ip: ip_address
        node.hostmanager.aliases = [ "www." + project_name + ".local" ]
    end
    config.vm.provision :hostmanager

    # Configure ports
    config.vm.network :forwarded_port, guest: 7171, host: 7171
    config.vm.network :forwarded_port, guest: 7172, host: 7172

end
