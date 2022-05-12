# k8s-lab

How to have a Kubernetes Cluster on your lab at a snap of fingers!

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

| Host       | IP            |
| ---------- | ------------- |
| k8s-master | 192.168.56.10 |
| k8s-node1  | 192.168.56.11 |
| k8s-node2  | 192.168.56.12 |

*ip range of 192.168.56.0/21 is the default for host-only networks of VirtualBox, it can be changed editing /etc/vbox/networks.conf and then editing variable IP_BASE on Vagrantfile.

## List of Features

 - [X] Ubuntu 20.04 LTS
 - [x] Ansible provisioning
 - [x] Calico Network
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

 ## Deploying Kubernetes Dashboard

From master (vagrant ssh k8s-master):

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

kubectl apply -f deployments/kubernetes_dashboard_node-port.yaml
```

Obtain authentication token:

```
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```

Access the Kubernetes Dashboard using the URL https://192.168.50.11:30002/#/login using the token printed before.

Created with :heart: using VScodium and Debian Linux.

Made in Brazil :brazil:
