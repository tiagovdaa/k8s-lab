# k8s-lab

How to have a Kubernetes Cluster on your lab at a snap of fingers!

<img src="/home/tiago/maxresdefault.jpg" style="zoom:25%;" />

*and not dying for it! :-)*

## Purpose

Our main goal is to setup a multi node Kubernetes cluster for development or study purposes. This setup provides a production-like cluster that can be setup on your local machine.

![Peek 08-02-2021 12-06](https://user-images.githubusercontent.com/1900641/107238354-82b24000-6a06-11eb-9d12-0fed6fbccb0a.gif)


## Pre-requisites

### Hardware 

- CPU: 4 cores or more
- MEM: 8GB or more
- HD: 120 GB or more

### Software

- VirtualBox 6.1 or higher
- Vagrant 2.2.10 or higher 
- Ansible 2.9.17 or higher

## Architecture

| Host |     IP      |
|------|-------------|
|master|192.168.10.10|
|mode1 |192.168.10.11|
|mode2 |192.168.10.12|

## List of Features

 - [X] VMs with O.S. Installed
 - [X] Ansible provisioning
 - [X] Container runtime installed (containerd)
 - [X] Kubernetes tools installed (kubeadm, kubectl)
 - [X] Master Node initialization (kubeadm)
 - [X] Nodes join

 ## How to use it
```
 git clone https://github.com/tiagovdaa/k8s-lab.git
 cd k8s-lab
 vagrant up
```

Created with :heart: using VScodium and Debian Linux.

Made in Brazil :brazil: