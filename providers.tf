# providers.tf

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.8.3"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.3"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}
