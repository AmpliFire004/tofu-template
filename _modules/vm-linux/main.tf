terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.93.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0"
    }
  }
}


resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.vm_name
  node_name   = var.node_name
  machine     = "q35"
  bios        = "ovmf"
  description = var.description
  scsi_hardware = "virtio-scsi-single"
  protection  = var.protection
  on_boot     = var.on_boot

  clone {
    vm_id     = var.clone_vm_id
    node_name = var.clone_node_name
    full      = true
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory_dedicated
  }

  network_device {
    model    = "virtio"
    bridge   = var.bridge
    vlan_id  = var.vlan_id
  }

  initialization {
    vendor_data_file_id = var.vendor_data_file_id
    datastore_id        = var.datastore_id
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }
    user_account {
      username = var.username
      password = var.password
      keys     = var.ssh_keys
    }
  }

  agent {
    enabled = true
  }

  efi_disk {
    datastore_id       = var.efi_datastore_id
    type               = "4m"
    pre_enrolled_keys  = true
  }

  disk {
    datastore_id = var.disk_datastore_id
    interface    = var.disk_interface
    iothread     = var.disk_iothread
    discard      = var.disk_discard
    size         = var.disk_size
    file_format  = var.disk_file_format
  }

  lifecycle {
    ignore_changes = [
      efi_disk[0].pre_enrolled_keys
    ]
  }
}