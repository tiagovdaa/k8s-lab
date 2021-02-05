#!/bin/bash

echo "installing apt-transport-https and adding kubernetes.io repository"

sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

echo "Updating System Repo"

sudo apt-get update

echo "Configuring requisites for Containerd"

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

echo "Installing Containerd"

sudo apt-get install -y containerd
# Configure containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
# Restart containerd
sudo systemctl restart containerd

echo "Installing Kubernetes tools (kubeadm, kubectl)"

sudo apt install kubelet kubeadm kubectl kubernetes-cni -y
sudo apt-mark hold kubelet kubeadm kubectl 
