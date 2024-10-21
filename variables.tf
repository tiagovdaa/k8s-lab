# variables.tf

variable "os_image_url" {
  description = "URL to the base OS image file"
  type        = string
}

variable "os_image_local_path" {
  description = "Local path where the OS image will be downloaded"
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

variable "master_count" {
  description = "Number of master nodes"
  type        = number
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
}

variable "master_memory" {
  description = "Memory (in MB) for each master node"
  type        = number
}

variable "master_vcpu" {
  description = "Number of vCPUs for each master node"
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

variable "master_hostname_prefix" {
  description = "Hostname prefix for master nodes"
  type        = string
}

variable "worker_hostname_prefix" {
  description = "Hostname prefix for worker nodes"
  type        = string
}

variable "network_name" {
  description = "Name of the existing libvirt network to use"
  type        = string
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

variable "master_disk_size" {
  description = "Disk size for master nodes in GB"
  type        = number
  default     = 20  # Default size in GB
}

variable "worker_disk_size" {
  description = "Disk size for worker nodes in GB"
  type        = number
  default     = 20  # Default size in GB
}