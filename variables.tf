variable "os_image_url" {
  description = "URL to the base OS image file"
  type        = string
}

variable "os_image_local_path" {
  description = "Local path where the OS image will be downloaded"
  type        = string
}

variable "network_name" {
  description = "Name of the existing libvirt network to use"
  type        = string
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