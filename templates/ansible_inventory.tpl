[all:vars]
ansible_user=${username}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_python_interpreter=/usr/bin/python3
kubernetes_container_runtime=${kubernetes_container_runtime}
kubernetes_package_version=${kubernetes_package_version}
kubernetes_version=${kubernetes_version}
crio_version=${crio_version}
containerd_version=${containerd_version}

[admin]
${admin_ip}

[masters]
${masters}

[workers]
${workers}
