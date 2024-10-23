# ===============================================
# 1. SSH Connectivity Checks for Admin, Masters, Workers
# ===============================================

# SSH Check for Admin Node
resource "null_resource" "wait_for_ssh_admin" {
  # Ensure this runs after the admin domain is created
  depends_on = [libvirt_domain.admin]

  connection {
    type        = "ssh"
    user        = local.username
    private_key = file(var.ssh_private_key_path)
    host        = var.admin_use_dhcp ? libvirt_domain.admin.network_interface[0].addresses[0] : var.admin_ip
    timeout     = "10m"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Admin node is accessible via SSH.'"]
  }
}

# SSH Check for Master Nodes
resource "null_resource" "wait_for_ssh_masters" {
  count = var.master_count

  # Ensure this runs after the respective master domain is created
  depends_on = [libvirt_domain.masters]

  connection {
    type        = "ssh"
    user        = local.username
    private_key = file(var.ssh_private_key_path)
    host        = var.masters_use_dhcp ? libvirt_domain.masters[count.index].network_interface[0].addresses[0] : var.master_ips[count.index]
    timeout     = "10m"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Master node ${count.index + 1} is accessible via SSH.'"]
  }
}

# SSH Check for Worker Nodes
resource "null_resource" "wait_for_ssh_workers" {
  count = var.worker_count

  # Ensure this runs after the respective worker domain is created
  depends_on = [libvirt_domain.workers]

  connection {
    type        = "ssh"
    user        = local.username
    private_key = file(var.ssh_private_key_path)
    host        = var.workers_use_dhcp ? libvirt_domain.workers[count.index].network_interface[0].addresses[0] : var.worker_ips[count.index]
    timeout     = "10m"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Worker node ${count.index + 1} is accessible via SSH.'"]
  }
}

# ===============================================
# 2. Ansible Inventory Generation
# ===============================================

# Generate Ansible inventory file using templatefile
resource "local_file" "ansible_inventory" {
  # Ensure inventory is generated after all SSH checks are complete
  depends_on = [
    null_resource.wait_for_ssh_admin,
    null_resource.wait_for_ssh_masters,
    null_resource.wait_for_ssh_workers
  ]

  content = templatefile("${path.module}/templates/ansible_inventory.tpl", {
    admin_ip   = var.admin_use_dhcp ? libvirt_domain.admin.network_interface[0].addresses[0] : var.admin_ip
    master_ips = var.masters_use_dhcp ? [for m in libvirt_domain.masters : m.network_interface[0].addresses[0]] : var.master_ips
    worker_ips = var.workers_use_dhcp ? [for w in libvirt_domain.workers : w.network_interface[0].addresses[0]] : var.worker_ips
    username   = local.username
  })
  
  filename = "${path.module}/ansible/inventory.ini"
}

# ===============================================
# 3. Ansible Playbook Execution
# ===============================================

# Execute Ansible Playbook
resource "null_resource" "ansible_provision" {
  # Ensure Ansible runs after inventory is generated
  depends_on = [
    local_file.ansible_inventory
  ]

  provisioner "local-exec" {
    environment = {
      ANSIBLE_CONFIG = "${path.module}/ansible/ansible.cfg"
    }
    command = <<EOT
    ansible-playbook -i ${path.module}/ansible/inventory.ini ansible/playbook.yml --private-key ${var.ssh_private_key_path}
    EOT
  }
}
