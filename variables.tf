variable "os_image_url" {
  description = "URL to the base OS image file"
  type        = string
}

variable "base_image_pool_name" {
  description = "Name of the storage pool for base images"
  type        = string
  default     = "images"
}

variable "create_base_image_pool" {
  description = "Set to true to create the base image storage pool if it doesn't exist"
  type        = bool
  default     = false
}

variable "base_image_pool_path" {
  description = "Filesystem path for the base image storage pool (required if create_base_image_pool is true)"
  type        = string
  default     = "/var/lib/libvirt/images"
}

variable "vm_disk_pool_name" {
  description = "Name of the storage pool for VM disks"
  type        = string
  default     = "vms"
}

variable "create_vm_disk_pool" {
  description = "Set to true to create the VM disks storage pool if it doesn't exist"
  type        = bool
  default     = false
}

variable "vm_disk_pool_path" {
  description = "Filesystem path for the VM disks storage pool (required if create_vm_disk_pool is true)"
  type        = string
  default     = "/var/lib/libvirt/vms"
}

variable "network_name" {
  description = "Name of the network to use"
  type        = string
  default     = "default"
}

variable "network_mode" {
  description = "Network mode: nat, isolated, etc."
  type        = string
  default     = "nat"
}

variable "network_address" {
  description = "Base network address (e.g., '192.168.100.0')"
  type        = string
  default     = "192.168.100.0"
}

variable "netmask" {
  description = "Netmask for static IP configuration (in CIDR notation, e.g., '24')"
  type        = string
  default     = "24"
}

variable "gateway" {
  description = "Gateway for static IP configuration"
  type        = string
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "network_domain" {
  description = "Domain name for the network (optional)"
  type        = string
  default     = "k8s.local"
}

variable "create_network" {
  description = "Set to true to create the network, false to use an existing network"
  type        = bool
  default     = false
}

variable "ssh_private_key_path" {
  description = "Path to your existing SSH private key"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to your existing SSH public key"
  type        = string
}

variable "admin_hostname" {
  description = "Hostname for the admin node"
  type        = string
}

variable "admin_use_dhcp" {
  description = "Whether to use DHCP for the admin node"
  type        = bool
  default     = true
}

variable "admin_ip" {
  description = "Static IP address for the admin node"
  type        = string
  default     = ""

  validation {
    condition     = var.admin_use_dhcp || (var.admin_ip != "")
    error_message = "You must provide 'admin_ip' when 'admin_use_dhcp' is false."
  }
}

variable "admin_memory" {
  description = "Memory (in MB) for the admin node"
  type        = number
  default     = 1024
}

variable "admin_vcpu" {
  description = "Number of vCPUs for the admin node"
  type        = number
  default     = 1
}

variable "admin_disk_size" {
  description = "Disk size for the admin node in GB"
  type        = number
  default     = 10
}

variable "master_hostname_prefix" {
  description = "Hostname prefix for master nodes"
  type        = string
}

variable "master_count" {
  description = "Number of master nodes (must be an odd number)"
  type        = number

  validation {
    condition     = var.master_count % 2 == 1
    error_message = "The 'master_count' variable must be an odd number (e.g., 1, 3, 5, ...)."
  }
}

variable "masters_use_dhcp" {
  description = "Whether to use DHCP for master nodes"
  type        = bool
  default     = false
}

variable "master_ips" {
  description = "List of static IPs for master nodes"
  type        = list(string)
  default     = []

  validation {
    condition     = var.masters_use_dhcp || length(var.master_ips) > 0
    error_message = "You must provide 'master_ips' when 'masters_use_dhcp' is false."
  }
}

variable "master_memory" {
  description = "Memory (in MB) for each master node"
  type        = number
}

variable "master_vcpu" {
  description = "Number of vCPUs for each master node"
  type        = number
}

variable "master_disk_size" {
  description = "Disk size for master nodes in GB"
  type        = number
  default     = 20
}

variable "worker_hostname_prefix" {
  description = "Hostname prefix for worker nodes"
  type        = string
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
}

variable "workers_use_dhcp" {
  description = "Whether to use DHCP for worker nodes"
  type        = bool
  default     = false
}

variable "worker_ips" {
  description = "List of static IPs for worker nodes"
  type        = list(string)
  default     = []

  validation {
    condition     = var.workers_use_dhcp || length(var.worker_ips) > 0
    error_message = "You must provide 'worker_ips' when 'workers_use_dhcp' is false."
  }
}

variable "worker_memory" {
  description = "Memory (in MB) for each worker node"
  type        = number
}

variable "worker_vcpu" {
  description = "Number of vCPUs for each worker node"
  type        = number
}

variable "worker_disk_size" {
  description = "Disk size for worker nodes in GB"
  type        = number
  default     = 20
}

variable "ansible_inventory_file" {
  description = "Path to the Ansible inventory file"
  type        = string
  default     = "./ansible/inventory.ini"
}

variable "ansible_playbook" {
  description = "Path to the Ansible playbook"
  type        = string
  default     = "./ansible/playbook.yml"
}

variable "kubernetes_version" {
  description = "Version of Kubernetes packages to install (e.g., '1.29.1')"
  type        = string
}

variable "kubernetes_package_version" {
  description = "Version of Kubernetes packages to install (e.g., '1.29.1-1.1')"
  type        = string
}

variable "containerd_version" {
  description = "Version of containerd to install (optional)"
  type        = string
  default     = ""
}

variable "control_plane_endpoint" {
  description = "Hostname for the control plane endpoint"
  type        = string
  default     = "k8scp"
}

variable "pod_subnet" {
  description = "CIDR for the pod network"
  type        = string
  default     = "192.168.0.0/16"
}

variable "cilium_version" {
  description = "Version of Cilium to install (e.g., '1.13.4')"
  type        = string
  default     = "1.14.1"
}

variable "cilium_namespace" {
  description = "Kubernetes namespace to install Cilium"
  type        = string
  default     = "cilium"
}

variable "cilium_image_repository" {
  description = "Cilium image repository"
  type        = string
  default     = "quay.io/cilium/cilium"
}

variable "kubeconfig_path" {
  description = "kubeconfig location"
  type        = string
  default     = "~/.kube/config"
}
