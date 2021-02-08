# k8s-lab

## Purpose

The purpose of this project is provide a full-blown Kubernetes LAB with minimum pain.

## Pre-requisites

### Hardware 

- CPU: 4 cores or more
- MEM: 8GB or more
- HD: 120 GB or more

### Software

- VirtualBox 6.1 or higher
- Vagrant 2.2.10 or higher 
- Ansible 2.9.17 or higher

# Architecture

|Host|IP|
|master|192.168.10.10|
|mode1|192.168.10.11|
|mode2|192.168.10.11|

## List of Features

 - [X] Hosts boots and are pre-configured
 - [X] Ansible provisioning
 - [X] Contairned installed
 - [X] Kubernetes tools are installed
 - [X] Master init
 - [X] Nodes join
 - [ ] User creation and ssh-keys import (only vagrant user is being used)

Created with :heart: using VScodium, Debian Linux in :brazil: