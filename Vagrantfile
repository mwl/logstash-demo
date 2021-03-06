# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"

  config.vm.provision "puppet" do |puppet|
    puppet.environment_path = "environments"
    # puppet.options = "--verbose --debug"
  end

  config.vm.define "zookeeper" do |zookeeper|
    zookeeper.vm.network "forwarded_port", guest: 2181, host: 2182
    zookeeper.vm.network "private_network", ip: "172.16.33.10"
    zookeeper.vm.hostname = "zookeeper"

    zookeeper.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
    end
    config.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "1024"
    end
  end

  config.vm.define "elasticsearch" do |elasticsearch|
    elasticsearch.vm.network "private_network", ip: "172.16.33.11"
    elasticsearch.vm.hostname = "elasticsearch"

    elasticsearch.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
    config.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "1024"
    end
  end

  config.vm.define "mesosmaster" do |mesosmaster|
    mesosmaster.vm.network "forwarded_port", guest: 5050, host: 5050
    mesosmaster.vm.network "private_network", ip: "172.16.33.20"
    mesosmaster.vm.hostname = "mesosmaster"

    mesosmaster.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
    end
    config.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "256"
    end
  end

  config.vm.define "mesosslave1" do |mesosslave|
    mesosslave.vm.network "private_network", ip: "172.16.33.31"
    mesosslave.vm.hostname = "mesosslave1"

    mesosslave.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
    config.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "1024"
    end
  end

  config.vm.define "mesosslave2" do |mesosslave|
    mesosslave.vm.network "private_network", ip: "172.16.33.32"
    mesosslave.vm.hostname = "mesosslave2"

    mesosslave.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
    config.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "1024"
    end
  end

  config.vm.define "mesosslave3" do |mesosslave|
    mesosslave.vm.network "private_network", ip: "172.16.33.33"
    mesosslave.vm.hostname = "mesosslave3"

    mesosslave.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
    config.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "1024"
    end
  end

  config.vm.define "mesosslave4" do |mesosslave|
    mesosslave.vm.network "private_network", ip: "172.16.33.34"
    mesosslave.vm.hostname = "mesosslave4"

    mesosslave.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
    config.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "1024"
    end
  end
end
