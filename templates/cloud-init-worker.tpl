#cloud-config
hostname: ${hostname}
ssh_authorized_keys:
  - "${ssh_public_key}"

growpart:
  mode: auto
  devices: ['/']
  ignore_growroot_disabled: false

runcmd:
  - resize2fs /dev/vda1  # Adjust the device name as appropriate
