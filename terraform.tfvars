# Base OS image URL
os_image_url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"

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
network_name               = "k8s-lab"
create_network             = true
network_domain             = "lab.net"
network_address            = "10.0.0.0"
netmask                    = "24"
gateway                    = "10.0.0.1"
dns_servers                = ["10.0.0.1", "8.8.8.8", "8.8.4.4"]

# Admin Node Configuration
admin_hostname             = "libvirt-k8s-admin"
admin_use_dhcp             = false
admin_ip                   = "10.0.0.10"
admin_memory               = 2048
admin_vcpu                 = 2
admin_disk_size            = 20

# Master Nodes Configuration
master_hostname_prefix     = "libvirt-k8s-master"
masters_use_dhcp           = false
master_count               = 3
master_ips                 = ["10.0.0.11", "10.0.0.12", "10.0.0.13"]
master_memory              = 4096
master_vcpu                = 2
master_disk_size           = 20

# Worker Nodes Configuration
worker_count               = 3
worker_hostname_prefix     = "libvirt-k8s-worker"
workers_use_dhcp           = false
worker_ips                 = ["10.0.0.20", "10.0.0.21", "10.0.0.22"]
worker_memory              = 2048
worker_vcpu                = 2
worker_disk_size           = 40

# Kubernetes Configuration
containerd_version         = ""  
kubernetes_version         = "1.29.9"
kubernetes_package_version = "1.29.9-1.1" 
kubeconfig_path            = "/etc/kubernetes/admin.conf"
control_plane_endpoint     = "k8s-lab-master"  
pod_subnet                 = "10.244.0.0/16"
cilium_version             = "1.14.1" 
cilium_namespace           = "cilium"
cilium_image_repository    = "quay.io/cilium/cilium"