# outputs.tf

# Define locals to simplify expressions and avoid nested conditionals
locals {
  # Determine the admin IP address
  admin_ip_address = var.admin_use_dhcp ? (
    try(libvirt_domain.admin.network_interface[0].addresses[0], "IP not available")
  ) : var.admin_ip

  # Determine the master IPs
  master_ips_list = var.masters_use_dhcp ? [
    for master in libvirt_domain.masters : try(master.network_interface[0].addresses[0], "IP not available")
  ] : var.master_ips

  # Determine the worker IPs
  worker_ips_list = var.workers_use_dhcp ? [
    for worker in libvirt_domain.workers : try(worker.network_interface[0].addresses[0], "IP not available")
  ] : var.worker_ips
}

# Output the IP address of the admin node
output "admin_ip" {
  description = "IP address of the admin node"
  value       = local.admin_ip_address
}

# Output the IP addresses of the master nodes
output "master_ips" {
  description = "IP addresses of master nodes"
  value       = local.master_ips_list
}

# Output the IP addresses of the worker nodes
output "worker_ips" {
  description = "IP addresses of worker nodes"
  value       = local.worker_ips_list
}

# Output all node IPs (admin, masters, and workers)
output "all_node_ips" {
  description = "IP addresses of all nodes (admin, masters, and workers)"
  value       = concat(
    [local.admin_ip_address],
    local.master_ips_list,
    local.worker_ips_list
  )
}

# Output the hostname of the admin node
output "admin_hostname" {
  description = "Hostname of the admin node"
  value       = var.admin_hostname
}

# Output the hostnames of the master nodes
output "master_hostnames" {
  description = "Hostnames of master nodes"
  value       = [for i in range(var.master_count) : "${var.master_hostname_prefix}-${i}"]
}

# Output the hostnames of the worker nodes
output "worker_hostnames" {
  description = "Hostnames of worker nodes"
  value       = [for i in range(var.worker_count) : "${var.worker_hostname_prefix}-${i}"]
}

# Output all node hostnames (admin, masters, and workers)
output "all_node_hostnames" {
  description = "Hostnames of all nodes (admin, masters, and workers)"
  value       = concat(
    [var.admin_hostname],
    [for i in range(var.master_count) : "${var.master_hostname_prefix}-${i}"],
    [for i in range(var.worker_count) : "${var.worker_hostname_prefix}-${i}"]
  )
}
