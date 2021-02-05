#!/bin/bash
sudo apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |sudo apt-key add -

sudo cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
  deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt update

sudo apt install docker.io -y
sudo apt install kubelet kubeadm kubectl kubernetes-cni -y
sudo systemctl enable docker
#kubeadm init --control-plane-endpoint 10.0.0.2