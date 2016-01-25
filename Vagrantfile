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

  def define_slave(config, i)
    config.vm.define ("mesosslave" + i.to_s) do |mesosslave|
      mesosslave.vm.network "private_network", ip: "172.16.33." + (30+i).to_s
      mesosslave.vm.hostname = "mesosslave" + i.to_s

      mesosslave.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
      config.vm.provider "vmware_fusion" do |vf|
        vf.vmx["memsize"] = "1024"
      end
    end
  end
  
  for i in 1..4
    define_slave(config, i)
  end
end
