# outputs.tf

output "admin_ip" {
  description = "IP address of admin node"
  value       = libvirt_domain.admin.network_interface[0].addresses[0]
}

output "master_ips" {
  description = "IP addresses of master nodes"
  value       = [for master in libvirt_domain.masters : master.network_interface[0].addresses[0]]
}

output "worker_ips" {
  description = "IP addresses of worker nodes"
  value       = [for worker in libvirt_domain.workers : worker.network_interface[0].addresses[0]]
}
