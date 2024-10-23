os_image_url               = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
os_image_local_path        = "./images/ubuntu-noble.img"
ssh_private_key_path       = "~/.ssh/id_rsa"
ssh_public_key_path        = "~/.ssh/id_rsa.pub"

# Network settings
network_name               = "k8s-lab"
create_network             = true
network_domain             = "lab.net"
network_address            = "10.0.0.0"
netmask                    = "24"
gateway                    = "10.0.0.1"
dns_servers                = ["10.0.0.1", "8.8.8.8", "8.8.4.4"]

# Admin Node Configuration
admin_hostname             = "libvirt-k8s-admin"
admin_use_dhcp             = true

# Master(s) Node(s) Configuration
master_hostname_prefix     = "libvirt-k8s-master"
masters_use_dhcp           = false
master_count               = 3
master_ips                 = ["10.0.0.11", "10.0.0.12", "10.0.0.13"]
master_memory              = 4096
master_vcpu                = 2
master_disk_size           = 20

# Worker(s) Node(s) Configuration
worker_count               = 3
worker_ips                 = ["10.0.0.20", "10.0.0.21", "10.0.0.22"]
worker_hostname_prefix     = "libvirt-k8s-tst-node"
workers_use_dhcp           = false
worker_memory              = 2048
worker_vcpu                = 2
worker_disk_size           = 40
