Vagrant.configure("2") do |config|
    config.vm.box = "debian/buster64"
    config.vm.network "public_network", bridge: "enp6s0"

    config.vm.define "master" do |master|
      master.vm.hostname = "master"      
    end

    config.vm.define "node1" do |node1|
      node1.vm.hostname = "master"
    end
  
    config.vm.define "node2" do |node2|
      node2.vm.hostname = "master"
    end

  end