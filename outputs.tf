output "admin_ip" {
  description = "IP address of the admin node"
  value       = var.admin_use_dhcp ? libvirt_domain.admin.network_interface[0].addresses[0] : var.admin_ip
}

output "master_ips" {
  description = "IP addresses of master nodes"
  value       = var.masters_use_dhcp ? [for master in libvirt_domain.masters : master.network_interface[0].addresses[0]] : var.master_ips
}

output "worker_ips" {
  description = "IP addresses of worker nodes"
  value       = var.workers_use_dhcp ? [for worker in libvirt_domain.workers : worker.network_interface[0].addresses[0]] : var.worker_ips
}
