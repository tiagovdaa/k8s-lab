# Ensure the images directory exists
resource "null_resource" "create_images_dir" {
  provisioner "local-exec" {
    command = "mkdir -p ./images"
  }
}

# Download the OS image if not present
resource "null_resource" "download_os_image" {
  depends_on = [null_resource.create_images_dir]

  provisioner "local-exec" {
    command = "if [ ! -f \"${var.os_image_local_path}\" ]; then wget -O \"${var.os_image_local_path}\" \"${var.os_image_url}\"; fi"
  }
}

# Create a base volume from the OS image
resource "libvirt_volume" "base_os_image" {
  name   = "base_os_image.qcow2"
  source = var.os_image_local_path
  format = "qcow2"

  depends_on = [null_resource.download_os_image]
}

# Create cloud-init disk for admin node
resource "libvirt_cloudinit_disk" "admin_cloudinit" {
  name           = "${var.admin_hostname}-cloudinit.iso"
  user_data = templatefile("${path.module}/templates/cloud-init-admin.tpl", {
    hostname        = var.admin_hostname
    ssh_public_key  = file(var.ssh_public_key_path)
    admin_use_dhcp = var.admin_use_dhcp
    admin_ip        = var.admin_use_dhcp ? "" : var.admin_ip
    netmask          = var.netmask
    gateway          = var.gateway
    dns_servers       = var.dns_servers
  })
  pool           = "default"
}

# Create storage volumes for admin node by cloning the base volume
resource "libvirt_volume" "admin_disk" {
  name           = "${var.admin_hostname}-disk.qcow2"
  base_volume_id = libvirt_volume.base_os_image.id
  format         = "qcow2"
  size           = var.admin_disk_size * 1024 * 1024 * 1024  # Convert GB to bytes
}

# Create cloud-init disks for master nodes
resource "libvirt_cloudinit_disk" "master_cloudinit" {
  count     = var.master_count
  name      = "${var.master_hostname_prefix}-${count.index}-cloudinit.iso"
  user_data = templatefile("${path.module}/templates/cloud-init-master.tpl", {
    hostname       = "${var.master_hostname_prefix}-${count.index}"
    ssh_public_key = file(var.ssh_public_key_path)
    masters_use_dhcp = var.masters_use_dhcp
    master_ip        = var.masters_use_dhcp ? "" : var.master_ips[count.index]
    netmask          = var.netmask
    gateway          = var.gateway
    dns_servers      = var.dns_servers
  })
  pool      = "default"
}

# Create storage volumes for master nodes by cloning the base volume
resource "libvirt_volume" "master_disk" {
  count          = var.master_count
  name           = "${var.master_hostname_prefix}-${count.index}-disk.qcow2"
  base_volume_id = libvirt_volume.base_os_image.id
  format         = "qcow2"
  size           = var.master_disk_size * 1024 * 1024 * 1024  # Convert GB to bytes
}

# Create cloud-init disks for worker nodes
resource "libvirt_cloudinit_disk" "worker_cloudinit" {
  count     = var.worker_count
  name      = "${var.worker_hostname_prefix}-${count.index}-cloudinit.iso"
  user_data = templatefile("${path.module}/templates/cloud-init-worker.tpl", {
    hostname       = "${var.worker_hostname_prefix}-${count.index}"
    ssh_public_key = file(var.ssh_public_key_path)
    workers_use_dhcp = var.workers_use_dhcp
    worker_ip        = var.workers_use_dhcp ? "" : var.worker_ips[count.index]
    netmask          = var.netmask
    gateway          = var.gateway
    dns_servers     = var.dns_servers    
    }
  )
  pool      = "default"
}

# Create storage volumes for worker nodes by cloning the base volume
resource "libvirt_volume" "worker_disk" {
  count          = var.worker_count
  name           = "${var.worker_hostname_prefix}-${count.index}-disk.qcow2"
  base_volume_id = libvirt_volume.base_os_image.id
  format         = "qcow2"
  size           = var.worker_disk_size * 1024 * 1024 * 1024  # Convert GB to bytes
}
