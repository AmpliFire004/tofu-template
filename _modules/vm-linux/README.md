# VM Linux Module

This Terraform module creates a Linux virtual machine on Proxmox by cloning from template VM ID 9000.

## Requirements

- Terraform/OpenTofu >= 1.0
- Proxmox provider (bpg/proxmox) >= 0.93.0

## Providers

| Name | Version |
|------|---------|
| proxmox | >= 0.93.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vm_name | Name of the VM | `string` | n/a | yes |
| node_name | Proxmox node name where the VM will be created | `string` | n/a | yes |
| description | Description of the VM | `string` | `"VM created with Terraform"` | no |
| protection | Whether the VM is protected | `bool` | `false` | no |
| on_boot | Whether the VM starts on boot | `bool` | `false` | no |
| clone_vm_id | VM ID of the template to clone from | `number` | `9000` | no |
| clone_node_name | Node name where the template is located | `string` | n/a | yes |
| cpu_cores | Number of CPU cores | `number` | `4` | no |
| memory_dedicated | Dedicated memory in MB | `number` | `4096` | no |
| bridge | Network bridge | `string` | `"LabServer"` | no |
| vlan_id | VLAN ID for the network | `number` | n/a | yes |
| vendor_data_file_id | Vendor data file ID | `string` | `"local:snippets/postclone.yml"` | no |
| datastore_id | Datastore ID for initialization | `string` | `"msa_lvm"` | no |
| ip_address | IP address for the VM | `string` | n/a | yes |
| gateway | Gateway IP address | `string` | `null` | no |
| username | Username for the VM user | `string` | `"eostest"` | no |
| password | Password for the VM user | `string` | n/a | yes |
| ssh_keys | List of SSH public keys | `list(string)` | n/a | yes |
| efi_datastore_id | Datastore ID for EFI disk | `string` | `"msa_lvm"` | no |
| disk_datastore_id | Datastore ID for the disk | `string` | `"msa_lvm"` | no |
| disk_interface | Disk interface | `string` | `"scsi0"` | no |
| disk_iothread | Enable iothread for disk | `bool` | `true` | no |
| disk_discard | Disk discard policy | `string` | `"on"` | no |
| disk_size | Disk size in GB | `number` | `20` | no |
| disk_file_format | Disk file format | `string` | `"qcow2"` | no |
| ansible_groups | Groups this host should belong to in Ansible inventory for grouping | `list(string)` | `[]` | no |
| ansible_vars | Extra hostvars for Ansible inventory | `map(any)` | `{}` | no |
| ansible_hostname | Inventory hostname (defaults to vm_name) | `string` | `null` | no |
| domain | DNS domain name to create FQDN and set search domain | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ansible_host | Ansible inventory host information |
| vm_id | The ID of the created VM |

## Example Usage

```hcl
module "linux_vm" {
  source = "../modules/vm-linux"

  vm_name          = "my-linux-vm"
  node_name        = "pve1"
  clone_node_name  = "pve2"
  vlan_id          = 170
  domain           = "example.com"
  ip_address       = "dhcp"
  username         = "eostest"
  password         = var.vm_password
  ssh_keys         = [for p in var.ssh_keys : trimspace(file(p))]
  disk_size        = 50
}
```

## Notes

- The VM is cloned from template ID 9000 by default.
- Initialization includes vendor data file for post-clone setup.
- SSH keys are added for passwordless login.
- The VM uses OVMF BIOS and VirtIO hardware.
