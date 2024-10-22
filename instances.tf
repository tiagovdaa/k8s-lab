# Generate cloud-init templates for admin node
data "template_file" "admin_cloud_init" {
  template = file("${path.module}/templates/cloud-init-admin.tpl")

  vars = {
    hostname       = "${var.admin_hostname}"
    ssh_public_key = file(var.ssh_public_key_path)
  }
}

# Create cloud-init disks for admin node
resource "libvirt_cloudinit_disk" "admin_cloudinit" {
  name      = "${var.admin_hostname}-cloudinit.iso"
  user_data = data.template_file.admin_cloud_init.rendered
}

# Create admin node
resource "libvirt_domain" "admin" {
  name   = "${var.admin_hostname}"
  memory = var.admin_memory
  vcpu   = var.admin_vcpu

  disk {
    volume_id = libvirt_volume.admin_disk.id
  }

  network_interface {
    network_name   = var.network_name
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.admin_cloudinit.id
}

# Generate cloud-init templates for master nodes
data "template_file" "master_cloud_init" {
  count    = var.master_count
  template = file("${path.module}/templates/cloud-init-master.tpl")

  vars = {
    hostname       = "${var.master_hostname_prefix}-${count.index}"
    ssh_public_key = file(var.ssh_public_key_path)
  }
}

# Create cloud-init disks for master nodes
resource "libvirt_cloudinit_disk" "master_cloudinit" {
  count     = var.master_count
  name      = "${var.master_hostname_prefix}-${count.index}-cloudinit.iso"
  user_data = data.template_file.master_cloud_init[count.index].rendered
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
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.master_cloudinit[count.index].id
}

# Generate cloud-init templates for worker nodes
data "template_file" "worker_cloud_init" {
  count    = var.worker_count
  template = file("${path.module}/templates/cloud-init-worker.tpl")

  vars = {
    hostname       = "${var.worker_hostname_prefix}-${count.index}"
    ssh_public_key = file(var.ssh_public_key_path)
  }
}

# Create cloud-init disks for worker nodes
resource "libvirt_cloudinit_disk" "worker_cloudinit" {
  count     = var.worker_count
  name      = "${var.worker_hostname_prefix}-${count.index}-cloudinit.iso"
  user_data = data.template_file.worker_cloud_init[count.index].rendered
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
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.worker_cloudinit[count.index].id
}
