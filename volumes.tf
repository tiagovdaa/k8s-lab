# Create base image storage pool if required
resource "libvirt_pool" "base_image_pool" {
  count = var.create_base_image_pool ? 1 : 0

  name = var.base_image_pool_name
  type = "dir"

  target {
    path = var.base_image_pool_path
  }
}

# Create VM disks storage pool if required
resource "libvirt_pool" "vm_disk_pool" {
  count = var.create_vm_disk_pool ? 1 : 0

  name = var.vm_disk_pool_name
  type = "dir"

  target {
    path = var.vm_disk_pool_path
  }
}

# Create a base volume from the OS image URL
resource "libvirt_volume" "base_os_image" {
  name   = "${var.os_flavor}_base_image.qcow2"
  pool   = var.base_image_pool_name
  source = var.os_image_url != "" ? var.os_image_url : local.os_images[var.os_flavor]["url"]
  format = var.os_image_format != "" ? var.os_image_format : local.os_images[var.os_flavor]["format"]

  depends_on = [libvirt_pool.base_image_pool]
}


# Create cloud-init disk for admin node
resource "libvirt_cloudinit_disk" "admin_cloudinit" {
  name           = "${var.admin_hostname}-cloudinit.iso"
  user_data      = templatefile("${path.module}/templates/cloud-init-admin.tpl", {
    hostname       = var.admin_hostname
    ssh_public_key = file(var.ssh_public_key_path)
    username       = var.os_flavor
  })
  network_config = templatefile("${path.module}/templates/network-config-admin.tpl", {
    admin_use_dhcp = var.admin_use_dhcp
    admin_ip       = var.admin_use_dhcp ? "" : var.admin_ip
    netmask        = var.netmask
    gateway        = var.gateway
    dns_servers    = var.dns_servers
    network_interface = local.netinf
  })
  pool           = var.vm_disk_pool_name

  depends_on = [libvirt_pool.vm_disk_pool]
}

# Create storage volume for admin node by cloning the base volume
resource "libvirt_volume" "admin_disk" {
  name           = "${var.admin_hostname}-disk.qcow2"
  base_volume_id = libvirt_volume.base_os_image.id
  format         = "qcow2"
  size           = var.admin_disk_size * 1024 * 1024 * 1024  # Convert GB to bytes
  pool           = var.vm_disk_pool_name

  depends_on = [libvirt_pool.vm_disk_pool]
}

# Create cloud-init disks for master nodes
resource "libvirt_cloudinit_disk" "master_cloudinit" {
  count     = var.master_count
  name      = "${var.master_hostname_prefix}-${count.index}-cloudinit.iso"
  user_data = templatefile("${path.module}/templates/cloud-init-master.tpl", {
    hostname       = "${var.master_hostname_prefix}-${count.index}"
    ssh_public_key = file(var.ssh_public_key_path)
    username       = var.os_flavor
  })
  network_config = templatefile("${path.module}/templates/network-config-master.tpl", {
    masters_use_dhcp = var.masters_use_dhcp
    master_ip        = var.masters_use_dhcp ? "" : var.master_ips[count.index]
    netmask          = var.netmask
    gateway          = var.gateway
    dns_servers      = var.dns_servers
    network_interface = local.netinf
  })
  pool      = var.vm_disk_pool_name

  depends_on = [libvirt_pool.vm_disk_pool]
}

# Create storage volumes for master nodes by cloning the base volume
resource "libvirt_volume" "master_disk" {
  count          = var.master_count
  name           = "${var.master_hostname_prefix}-${count.index}-disk.qcow2"
  base_volume_id = libvirt_volume.base_os_image.id
  format         = "qcow2"
  size           = var.master_disk_size * 1024 * 1024 * 1024  # Convert GB to bytes
  pool           = var.vm_disk_pool_name

  depends_on = [libvirt_pool.vm_disk_pool]
}

# Create cloud-init disks for worker nodes
resource "libvirt_cloudinit_disk" "worker_cloudinit" {
  count     = var.worker_count
  name      = "${var.worker_hostname_prefix}-${count.index}-cloudinit.iso"
  user_data = templatefile("${path.module}/templates/cloud-init-worker.tpl", {
    hostname       = "${var.worker_hostname_prefix}-${count.index}"
    ssh_public_key = file(var.ssh_public_key_path)
    username       = var.os_flavor
  })
  network_config = templatefile("${path.module}/templates/network-config-worker.tpl", {
    workers_use_dhcp = var.workers_use_dhcp
    worker_ip        = var.workers_use_dhcp ? "" : var.worker_ips[count.index]
    netmask          = var.netmask
    gateway          = var.gateway
    dns_servers      = var.dns_servers
    network_interface = local.netinf
  })
  pool      = var.vm_disk_pool_name

  depends_on = [libvirt_pool.vm_disk_pool]
}

# Create storage volumes for worker nodes by cloning the base volume
resource "libvirt_volume" "worker_disk" {
  count          = var.worker_count
  name           = "${var.worker_hostname_prefix}-${count.index}-disk.qcow2"
  base_volume_id = libvirt_volume.base_os_image.id
  format         = "qcow2"
  size           = var.worker_disk_size * 1024 * 1024 * 1024  # Convert GB to bytes
  pool           = var.vm_disk_pool_name

  depends_on = [libvirt_pool.vm_disk_pool]
}
