# provisioning.tf

# Wait for all nodes to be accessible via SSH
resource "null_resource" "wait_for_ssh" {
  depends_on = [libvirt_domain.masters, libvirt_domain.workers]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_private_key_path)
    host        = libvirt_domain.masters[0].network_interface[0].addresses[0]
    timeout     = "10m"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Master node is accessible via SSH.'"]
  }
}

# Generate Ansible inventory
resource "null_resource" "generate_inventory" {
  depends_on = [null_resource.wait_for_ssh]

  provisioner "local-exec" {
    command = <<EOF
cat > ${var.ansible_inventory_file} <<EOL
[masters]
${join("\n", [for master in libvirt_domain.masters : "${master.name} ansible_host=${master.network_interface[0].addresses[0]}"])}
  
[workers]
${join("\n", [for worker in libvirt_domain.workers : "${worker.name} ansible_host=${worker.network_interface[0].addresses[0]}"])}
  
[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${var.ssh_private_key_path}
kubernetes_version=${var.kubernetes_version}
kubernetes_package_version=${var.kubernetes_package_version}
containerd_version=${var.containerd_version}
control_plane_endpoint=${var.control_plane_endpoint}
pod_subnet=${var.pod_subnet}
cilium_version=${var.cilium_version}
cilium_namespace=${var.cilium_namespace}
kubeconfig_path=${var.kubeconfig_path}
EOL
EOF
  }
}


# Run Ansible playbook
resource "null_resource" "provision_cluster" {
  depends_on = [null_resource.generate_inventory]

  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=./ansible/ansible.cfg ansible-playbook -i ${var.ansible_inventory_file} ${var.ansible_playbook}"
  }
}
