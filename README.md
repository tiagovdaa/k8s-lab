# Terraform Libvirt (kvm) Deployment
Using Terraform to Provision VMs on Libvirt (KVM)

This project uses Terraform to deploy multiple virtual machines (VMs) on a Libvirt hypervisor, utilizing Cloud-Init for initial configuration. The setup is fully parameterized, allowing you to specify the number of VMs, base images, and storage pools. 

## Prerequisites

Before you begin, ensure that your system meets the following requirements:

1. **Libvirt and QEMU Installed**:
   - Ensure that Libvirt and QEMU are installed and properly configured on your system.

2. **QEMU Configuration Fix**:
   - On Ubuntu distributions, SELinux is enforced by QEMU even if it is disabled globally. This might cause unexpected `Permission denied` errors. To prevent this, make sure that `security_driver = "none"` is uncommented in `/etc/libvirt/qemu.conf`:
     ```bash
     sudo vim /etc/libvirt/qemu.conf
     ```
     Uncomment the line:
     ```bash
     security_driver = "none"
     ```
     Save the file and restart the Libvirt service:
     ```bash
     sudo systemctl restart libvirtd
     ```

3. **Terraform Installed**:
   - Install Terraform by following the instructions [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).

**NOTE**

Since there are no official provider for libvirt, I'm using this one [here](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs) and there are some limitations regarding features.

## Project Structure

- **`main.tf`**: Defines the primary Terraform configuration for VM creation.
- **`volumes.tf`**: Manages the base images and storage pools for the VMs.
- **`variables.tf`**: Contains variable definitions used throughout the project.
- **`outputs.tf`**: Manages the outputs, such as the IP addresses of the created VMs.
- **`cloud_init.cfg`**: The Cloud-Init configuration template used for VM initialization.
- **`terraform.tfvars`**: Contains the variable values to customize the deployment (e.g., VM names, counts, storage pools).

## Usage

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Update the `terraform.tfvars` File

Edit the `terraform.tfvars` file to customize the deployment according to your needs:

```hcl
vm_count        = 3
vm_names        = ["k8s-master", "k8s-node-1", "k8s-node-2"]
memory_size     = 2048
vcpu_count      = 2
base_images     = [
  {
    name   = "noble-server-cloudimg-amd64.img"
    source = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  }
]
base_image_pool = "iso"
vm_pool         = "default"
cloudinit_pool  = "default"
network_name    = "default"
cloud_init_template = "cloud_init.cfg"  # Assuming this file is in the same directory as your Terraform files
```

### 3. Initialize Terraform

Run the following command to initialize Terraform:

```bash
terraform init
```

This command will download the necessary providers and set up the environment.

### 4. Plan the Deployment

To see what changes will be made by Terraform, run:

```bash
terraform plan
```

This step is optional but recommended to verify your configuration.

### 5. Apply the Configuration

Deploy the VMs by running:

```bash
terraform apply
```

Confirm the changes by typing `yes` when prompted.

### 6. Verify the Deployment

After Terraform completes, you can view the IP addresses of the deployed VMs:

```bash
terraform output vm_ips
```

You can also SSH into the VMs using the IP addresses provided.

### 7. Destroy the Infrastructure

To tear down the infrastructure created by Terraform, run:

```bash
terraform destroy
```

Confirm the destruction by typing `yes` when prompted.

## Troubleshooting

- **Permissions Error**: If you encounter a `Permission denied` error when Terraform tries to create a VM, ensure that the `security_driver = "none"` line is uncommented in `/etc/libvirt/qemu.conf` and that you have restarted the Libvirt service as described in the Prerequisites section.

- **Hostname Issues**: If all VMs have the same hostname, ensure that the `cloud_init.cfg` file is correctly using the `${hostname}` variable and that the `main.tf` file is passing unique hostnames for each VM.

- **VM Ips**: Sometimes IP was not assigned at the time terraform tries to output it, you can run a terraform plan to check if ip's output would be changed and then apply, this will not delete or rebuild the vms and will just update terraform outputs.

---

Created with ❤️ and Debian Linux.

by Tiago Almeida 🇧🇷🇵🇹
