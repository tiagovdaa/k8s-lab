%{ if workers_use_dhcp }
version: 2
ethernets:
  ens3:
    dhcp4: true
%{ else }
version: 2
ethernets:
  ens3:
    dhcp4: false
    addresses:
      - ${worker_ip}/${netmask}
    gateway4: ${gateway}
    nameservers:
      addresses:
%{ for dns in dns_servers ~}
          - ${dns}
%{ endfor ~}
%{ endif }