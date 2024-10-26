# Operating System Configuration
os_flavor                  = "ubuntu"
os_image_url               = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
os_image_format            = "qcow2"

# Storage pools
base_image_pool_name       = "images"
create_base_image_pool     = true
base_image_pool_path       = "/data/libvirt/cloud-images"
    
vm_disk_pool_name          = "vms"
create_vm_disk_pool        = true
vm_disk_pool_path          = "/data/libvirt/vms"
    
# SSH keys    
ssh_private_key_path       = "~/.ssh/id_rsa"
ssh_public_key_path        = "~/.ssh/id_rsa.pub"

# Network settings
network_name               = "default"
create_network             = false
network_domain             = "lab.net"
network_address            = "192.168.0.0"
netmask                    = "24"
gateway                    = "192.168.0.1"
dns_servers                = ["192.168.0.1", "8.8.8.8", "8.8.4.4"]

# Admin Node Configuration
admin_hostname             = "libvirt-k8s-admin"
admin_use_dhcp             = false
admin_ip                   = "192.168.0.10"
admin_memory               = 1024
admin_vcpu                 = 1
admin_disk_size            = 20

# Master Nodes Configuration
master_hostname_prefix     = "libvirt-k8s-master"
masters_use_dhcp           = false
master_count               = 1
master_ips                 = ["192.168.0.11"]#["10.0.0.11", "10.0.0.12", "10.0.0.13"]
master_memory              = 8192
master_vcpu                = 2
master_disk_size           = 20

# Worker Nodes Configuration
worker_hostname_prefix     = "libvirt-k8s-worker"
workers_use_dhcp           = false
worker_count               = 2
worker_ips                 = ["192.168.0.20","192.168.0.21"]#["10.0.0.20", "10.0.0.21", "10.0.0.22"]
worker_memory              = 4096
worker_vcpu                = 2
worker_disk_size           = 40

# Kubernetes Configuration

kubernetes_version             = "1.30.0"
kubernetes_package_version     = "1.30.0-1.1"
kubernetes_container_runtime   = "containerd"  # Options: containerd or cri-o
crio_version                   = "v1.30"  
containerd_version             = "1.7.2"       
