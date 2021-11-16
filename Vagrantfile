IMAGE_NAME = "ubuntu/focal64" #"debian/bullseye64"
K8S_NAME = "k8s-lab"
K8S_MASTER_CPU = 2
K8S_MASTER_MEM = 2048
K8S_MASTER_HOSTNAME = "k8s-master"

NODES_NUM = 2
NODES_CPU = 2
NODES_MEM = 2048

IP_BASE = "192.168.100."

VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

$DEFAULT_NETWORK_INTERFACE = `ip route | awk '/^default/ {printf "%s", $5; exit 0}'`

Vagrant.configure("2") do |config|
    config.vm.box = IMAGE_NAME
    config.ssh.insert_key = false

    config.vm.define K8S_MASTER_HOSTNAME do |master|
      master.vm.hostname = K8S_MASTER_HOSTNAME
      master.vm.network "private_network", ip: "#{IP_BASE}#{10}"
      master.vm.provider :virtualbox do |vb|
        vb.name = K8S_MASTER_HOSTNAME
        vb.cpus = K8S_MASTER_CPU
        vb.memory = K8S_MASTER_MEM
      end

      master.vm.provision "ansible" do |ansible|
        ansible.playbook = "roles/k8s.yml"
        ansible.extra_vars = {
          username: "#{ENV['USERNAME'] || `whoami`}",
          # Redefine defaults
          k8s_cluster_name: K8S_NAME,
          k8s_master_admin_user: "vagrant",
          k8s_master_admin_group: "vagrant",
          k8s_master_apiserver_advertise_address: "#{IP_BASE}#{10}",
          k8s_master_node_name: K8S_MASTER_HOSTNAME,
          k8s_node_public_ip: "#{IP_BASE}#{10}"
        }
      end

      $script = <<-SCRIPT
      echo "configured networks: \n"
      ip -br a |grep -i up|awk '{print "INTERFACE:",$1,"ADDRESS:",$3}'
      SCRIPT
      master.vm.provision "shell" do |shell|
        shell.inline = $script
      end
    end

    config.vm.synced_folder ".", "/vagrant", disabled: true
    node = ["k8s-node1","k8s-node2"]

    (1..NODES_NUM).each do |i|
    config.vm.define "k8s-node#{i}" do |node|
      node.vm.box = IMAGE_NAME
      node.vm.hostname = "k8s-node#{i}"
      node.vm.network :private_network, ip: "#{IP_BASE}#{10+i}", hostname: true
      node.vm.provider :virtualbox do |vb|
        vb.name = "k8s-node#{i}"
        vb.cpus = NODES_CPU
        vb.memory = NODES_MEM
      end
      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "roles/k8s.yml"
        ansible.extra_vars = {
            username: "#{ENV['USERNAME'] || `whoami`}",
            k8s_cluster_name:     K8S_NAME,
            k8s_node_admin_user:  "vagrant",
            k8s_node_admin_group: "vagrant",
            k8s_node_public_ip: "#{IP_BASE}#{i + 10}"
        }
      end
      $script = <<-SCRIPT
      echo "configured networks: \n"
      ip -br a |grep -i up|awk '{print "INTERFACE:",$1,"ADDRESS:",$3}'
      SCRIPT

      node.vm.provision "shell" do |shell|
        shell.inline = $script
      end
    end
  end
end