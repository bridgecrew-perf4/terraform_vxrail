provider "vsphere" {
  vsphere_server = var.vsphere_server
  user           = var.vsphere_user
  password       = var.vsphere_password

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

resource "vsphere_virtual_machine" "learn" {
  count = 10
  name             = "tf-on-vxrail-${count.index + 20}"
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
    size             = 210
  }

  guest_id = "ubuntu64Guest"

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu.id

  }
}

