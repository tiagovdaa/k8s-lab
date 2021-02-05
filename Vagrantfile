Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/groovy64"

    config.vm.define "master" do |master|
      master.vm.hostname = "k8s-master"
      master.vm.network "public_network", bridge: "wlxd0374588d04e"
      master.vm.network :private_network, ip: "192.168.10.10", hostname: true
      #master.vm.provision "shell", path: "provision.sh"
      master.vm.provider :virtualbox do |vb|
        vb.name = "k8s-master"
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
      end
    end

    config.vm.synced_folder ".", "/vagrant", disabled: true
    node = ["node1","node2"]
    N = 2
    
    (1..N).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.hostname = "k8s-node#{i}"
      node.vm.network :private_network, ip: "192.168.10.#{10+i}", hostname: true
      #node.vm.provision "shell", path: "provision.sh"
      node.vm.provider :virtualbox do |vb|
        vb.name = "k8s-node#{i}"
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "1"]
      end
    end
  end
end