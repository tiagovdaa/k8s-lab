variable "os_flavor" {
  description = "Operating system flavor: 'ubuntu', 'debian', 'rocky'"
  type        = string
  default     = "debian"
  validation {
    condition     = contains(["ubuntu", "debian", "rocky"], var.os_flavor)
    error_message = "Invalid 'os_flavor'. Allowed values are 'ubuntu', 'debian', 'rocky'."
  }
}

locals {
  os_details = {
    "ubuntu" = {
      url      = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
      format   = "qcow2"      
      network_interface = "ens3"
      username = "ubuntu"
    }
    "debian" = {
      url      = "https://cdimage.debian.org/cdimage/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
      format   = "qcow2"      
      network_interface = "ens3"
      username = "debian"
    }
    "rocky" = {
      url      = "https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2"
      format   = "qcow2"      
      network_interface = "eth0"
      username = "rocky"
    }
  }
  username = local.os_details[var.os_flavor]["username"]
  netinf = local.os_details[var.os_flavor]["network_interface"]
}

variable "os_image_url" {
  description = "URL to the base OS image file (overrides default for selected os_flavor)"
  type        = string
  default     = ""
}

variable "os_image_format" {
  description = "Format of the OS image (e.g., 'qcow2')"
  type        = string
  default     = ""
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

variable "cpu_mode" {
  description = "CPU mode"
  type        = string
  default     = "custom"
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
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key_path" {
  description = "Path to your existing SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
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

variable "ansible_ssh_private_key" {
  description = "Path to the SSH private key for Ansible to connect to the VMs"
  type        = string
  default     = "~/.ssh/id_rsa"  # Update as per your environment
}

variable "admin_user" {
  description = "SSH username for the admin node"
  type        = string
  default     = "debian"  # Update based on os_flavor
}

variable "master_user" {
  description = "SSH username for the master nodes"
  type        = string
  default     = "debian"  # Update based on os_flavor
}

variable "worker_user" {
  description = "SSH username for the worker nodes"
  type        = string
  default     = "debian"  # Update based on os_flavor
}

# Kubernetes Configuration

variable "kubernetes_package_version" {
  description = "Version of Kubernetes packages to install (e.g., '1.29.1-1.1')"
  type        = string
  default     = "1.29.1-1.1"
}

variable "kubernetes_version" {
  description = "Kubernetes version (e.g., '1.29.1') for YAML configurations and other uses"
  type        = string
  default     = "1.29.1"
}

variable "kubernetes_container_runtime" {
  description = "Container runtime to use for Kubernetes. Options: containerd, docker, cri-o"
  type        = string
  default     = "containerd"

  validation {
    condition     = contains(["containerd", "cri-o"], var.kubernetes_container_runtime)
    error_message = "kubernetes_container_runtime must be one of: containerd, docker, cri-o"
  }
}

# CRI-O Version
variable "crio_version" {
  description = "CRI-O version to install (e.g., 'v1.31')"
  type        = string
  default     = "v1.31"
}

# Containerd Version
variable "containerd_version" {
  description = "Containerd version to install (e.g., '1.6.4')"
  type        = string
  default     = "1.6.4"
}