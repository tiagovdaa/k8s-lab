# Create admin node
resource "libvirt_domain" "admin" {
  name   = var.admin_hostname
  memory = var.admin_memory
  vcpu   = var.admin_vcpu

  disk {
    volume_id = libvirt_volume.admin_disk.id
  }

  network_interface {
    network_name   = var.network_name
    wait_for_lease = var.admin_use_dhcp
    addresses      = var.admin_use_dhcp ? [] : [var.admin_ip]
  }

  cloudinit = libvirt_cloudinit_disk.admin_cloudinit.id
}

# Create master nodes
resource "libvirt_domain" "masters" {
  count = var.master_count

  name   = "${var.master_hostname_prefix}-${count.index}"
  memory = var.master_memory
  vcpu   = var.master_vcpu

  disk {
    volume_id = libvirt_volume.master_disk[count.index].id
  }

  network_interface {
    network_name   = var.network_name
    wait_for_lease = var.masters_use_dhcp
    addresses      = var.masters_use_dhcp ? [] : [var.master_ips[count.index]]
  }

  cloudinit = libvirt_cloudinit_disk.master_cloudinit[count.index].id
}

# Create worker nodes
resource "libvirt_domain" "workers" {
  count = var.worker_count

  name   = "${var.worker_hostname_prefix}-${count.index}"
  memory = var.worker_memory
  vcpu   = var.worker_vcpu

  disk {
    volume_id = libvirt_volume.worker_disk[count.index].id
  }

  network_interface {
    network_name   = var.network_name
    wait_for_lease = var.workers_use_dhcp
    addresses      = var.workers_use_dhcp ? [] : [var.worker_ips[count.index]]
  }

  cloudinit = libvirt_cloudinit_disk.worker_cloudinit[count.index].id
}