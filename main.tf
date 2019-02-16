data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "linux_vm_with_data" {
  name             = "${var.count == 1 ? var.role : "${var.role}${count.index + 1}"}"
  count            = "${var.os_type == "linux" && var.data_size_gb != "0" ? var.count : 0}"
  folder           = "${var.folder}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = "${var.num_cpus}"
  memory   = "${var.memory}"

  guest_id = "${var.guest_id}"

  tags = ["${vsphere_tag.role_name.id}"]

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "root"
    size  = "40"
  }

  disk {
    label       = "data"
    size        = "${var.data_size_gb}"
    unit_number = 1
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "${var.count == 1 ? var.role : "${var.role}${count.index + 1}"}"
        domain    = "${var.domain}"
      }

      network_interface {}
    }
  }
}

resource "vsphere_virtual_machine" "windows_vm_with_data" {
  name             = "${var.count == 1 ? var.role : "${var.role}${count.index + 1}"}"
  count            = "${var.os_type == "windows" && var.data_size_gb != "0" ? var.count : 0}"
  folder           = "${var.folder}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = "${var.num_cpus}"
  memory   = "${var.memory}"

  guest_id = "${var.guest_id}"

  tags = ["${vsphere_tag.role_name.id}"]

  network_interface {
    adapter_type = "e1000e"
    network_id   = "${data.vsphere_network.network.id}"
  }

  scsi_type = "lsilogic-sas"

  disk {
    label = "root"
    size  = "62"
  }

  disk {
    label       = "data"
    size        = "${var.data_size_gb}"
    unit_number = 1
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      windows_options {
        computer_name = "${var.count == 1 ? var.role : "${var.role}${count.index + 1}"}"
        workgroup     = "${var.workgroup}"
      }

      network_interface {}
    }
  }
}

resource "vsphere_tag" "role_name" {
  name        = "${var.role}"
  category_id = "${var.role_category_id}"
}
