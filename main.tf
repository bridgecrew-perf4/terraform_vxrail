terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "1.25.0"
    }
  }
}

provider "vsphere" {
  vsphere_server = var.vsphere_server
  user           = var.vsphere_user
  password       = var.vsphere_password

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

resource "vsphere_virtual_machine" "tf_vm" {
  name             = "tf-on-vxrail"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 4
  memory   = 16000

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  wait_for_guest_net_timeout = -1
  wait_for_guest_ip_timeout  = -1

  disk {
    label            = "disk0"
    thin_provisioned = true
    size             = 60
  }

  guest_id = "ubuntu64Guest"

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu.id

  }
}

/* ## Demo Changes
resource "vsphere_distributed_port_group" "tf_pg" {
  name                            = "pg"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.vxrail-dvs.id

  vlan_id = 10
} */