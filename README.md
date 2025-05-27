# Kubernetes Lab on Libvirt with Terraform

This project sets up a local Kubernetes cluster using Terraform, Libvirt, and QEMU. It's designed to provide an isolated environment to test multi-node Kubernetes setups on your local Linux machine.

## Features

* Fully declarative infrastructure with Terraform
* Cloud-init support for VM provisioning
* Configurable instance counts for admin, master, and worker nodes
* Automatic download and reuse of cloud images (Debian, Ubuntu, Rocky Linux)
* Ansible provisioning support (optional)

## Requirements

* Linux (Debian/Ubuntu recommended)
* KVM/QEMU
* Libvirt
* Terraform (>=1.0)
* Terraform Libvirt Provider

## Directory Structure

```
├── ansible/               # Optional Ansible provisioning roles
├── templates/             # Cloud-init and config templates
├── cloud-images-urls.txt  # Source URLs for base images
├── instances.tf           # VM definitions
├── networks.tf            # Network and bridges
├── outputs.tf             # Useful Terraform outputs
├── providers.tf           # Provider definitions
├── provisioning.tf        # Cloud-init provisioning logic
├── terraform.tfvars       # Custom variables (ignored by git)
├── variables.tf           # Variable definitions
├── volumes.tf             # Storage volume setup
```

## Usage

1. Clone the repository:

```bash
git clone https://github.com/tiagovdaa/k8s-lab.git
cd k8s-lab
```

2. Configure your preferences in `terraform.tfvars`:

```hcl
admin_hostname = "admin"
os_flavor = "debian"
admin_memory = 4096
...
```

3. Initialize Terraform:

```bash
terraform init
```

4. Apply the configuration:

```bash
terraform plan -out plan
terraform apply plan
```

5. Destroy the environment:

```bash
terraform destroy -auto-approve
```

## Troubleshooting

### Problem: Permission Denied on base image

**Symptom:**

```
Could not open '/var/lib/libvirt/images/debian_base_image.qcow2': Permission denied
```

**Cause:** AppArmor is blocking access to the image even though permissions look fine.

**Solution:** Set AppArmor to complain mode for Libvirt:

```bash
sudo aa-complain /etc/apparmor.d/libvirt/*
sudo systemctl reload apparmor
```

Or disable AppArmor completely (not recommended for production):

```bash
sudo systemctl disable --now apparmor
sudo sed -i 's/quiet splash/quiet splash apparmor=0/' /etc/default/grub
sudo update-grub
sudo reboot
```