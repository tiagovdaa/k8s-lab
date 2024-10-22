#cloud-config
hostname: ${hostname}
ssh_authorized_keys:
  - "${ssh_public_key}"
  
growpart:
  mode: auto
  devices: ['/']
  ignore_growroot_disabled: false

%{ if masters_use_dhcp }
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
%{ else }
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - ${master_ip}/${netmask}
      gateway4: ${gateway}
      nameservers:
        addresses:
%{ for dns in dns_servers ~}
          - ${dns}
%{ endfor ~}
%{ endif }

runcmd:
  - resize2fs /dev/sda1  # Adjust the device name as appropriate
