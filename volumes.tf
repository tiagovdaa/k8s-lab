# volumes.tf

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

# Create storage volumes for master nodes by cloning the base volume
resource "libvirt_volume" "master_disk" {
  count          = var.master_count
  name           = "${var.master_hostname_prefix}-${count.index}-disk.qcow2"
  base_volume_id = libvirt_volume.base_os_image.id
  format         = "qcow2"
  size           = var.master_disk_size * 1024 * 1024 * 1024  # Convert GB to bytes
}

# Create storage volumes for worker nodes by cloning the base volume
resource "libvirt_volume" "worker_disk" {
  count          = var.worker_count
  name           = "${var.worker_hostname_prefix}-${count.index}-disk.qcow2"
  base_volume_id = libvirt_volume.base_os_image.id
  format         = "qcow2"
  size           = var.worker_disk_size * 1024 * 1024 * 1024  # Convert GB to bytes
}
