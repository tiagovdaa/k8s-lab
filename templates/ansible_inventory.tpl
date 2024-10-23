[admin]
${admin_ip} ansible_user=${username}

[masters]
%{ for ip in master_ips ~}
${ip} ansible_user=${username}
%{ endfor ~}

[workers]
%{ for ip in worker_ips ~}
${ip} ansible_user=${username}
%{ endfor ~}
