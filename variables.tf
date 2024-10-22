variable "os_image_url" {
  description = "URL to the base OS image file"
  type        = string
}

variable "os_image_local_path" {
  description = "Local path where the OS image will be downloaded"
  type        = string
}

variable "network_name" {
  description = "Name of the network to use"
  type        = string
  default     = "default"
}

variable "use_dhcp" {
  description = "Whether to use DHCP for IP assignment"
  type        = bool
  default     = true
}

variable "netmask" {
  description = "Netmask for static IP configuration (in CIDR notation, e.g., '24')"
  type        = string
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

variable "ssh_private_key_path" {
  description = "Path to your existing SSH private key"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to your existing SSH public key"
  type        = string
}

variable "admin_hostname" {
  description = "Hostname prefix for master nodes"
  type        = string
}

variable "admin_use_dhcp" {
  description = "Whether to use DHCP for the admin node"
  type        = bool
  default     = true
}

variable "admin_ip" {
  description = "Static IP for the admin node (required if use_dhcp is false)"
  type        = string
  default     = ""
  
  validation {
    condition     = var.admin_use_dhcp || (var.admin_ip != "")
    error_message = "You must provide 'admin_ip' when 'use_dhcp' is false."
  }
}

variable "admin_memory" {
  description = "Memory (in MB) for each master node"
  type        = number
  default     = 1024
}

variable "admin_vcpu" {
  description = "Number of vCPUs for each master node"
  type        = number
  default     = 1
}

variable "admin_disk_size" {
  description = "Disk size for master nodes in GB"
  type        = number
  default     = 10  # Default size in GB
}

variable "master_hostname_prefix" {
  description = "Hostname prefix for master nodes"
  type        = string
}

variable "master_count" {
  type        = number
  description = "Number of master nodes (must be an odd number)"

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
  description = "List of static IPs for master nodes (required if use_dhcp is false)"
  type        = list(string)
  default     = []
  
  validation {
    condition     = var.masters_use_dhcp || length(var.master_ips) == var.master_count
    error_message = "You must provide 'master_ips' with exactly 'master_count' entries when 'use_dhcp' is false."
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
  default     = 20  # Default size in GB
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
  description = "List of static IPs for worker nodes (required if use_dhcp is false)"
  type        = list(string)
  default     = []
  
  validation {
    condition     = var.workers_use_dhcp || length(var.worker_ips) == var.worker_count
    error_message = "You must provide 'worker_ips' with exactly 'worker_count' entries when 'use_dhcp' is false."
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
  default     = 20  # Default size in GB
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
  type = string
  default = "~/.kube/config"
}