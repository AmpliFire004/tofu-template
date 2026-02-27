# VM Windows Module

This Terraform module creates a Windows virtual machine on Proxmox by cloning from template VM ID 9001. It supports automated provisioning with Ansible inventory generation.

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
| clone_vm_id | VM ID of the template to clone from | `number` | `9001` | no |
| clone_node_name | Node name where the template is located | `string` | n/a | yes |
| cpu_cores | Number of CPU cores | `number` | `4` | no |
| memory_dedicated | Dedicated memory in MB | `number` | `4096` | no |
| bridge | Network bridge | `string` | `"LabServer"` | no |
| vlan_id | VLAN ID for the network | `number` | n/a | yes |
| datastore_id | Datastore ID for initialization | `string` | `"msa_lvm"` | no |
| ip_address | IP address for the VM | `string` | n/a | yes |
| gateway | Gateway IP address | `string` | `null` | no |
| username | Username for the VM user | `string` | `"administrator"` | no |
| password | Password for the VM user | `string` | n/a | yes |
| efi_datastore_id | Datastore ID for EFI disk | `string` | `"msa_lvm"` | no |
| disk_datastore_id | Datastore ID for the disk | `string` | `"msa_lvm"` | no |
| disk_interface | Disk interface | `string` | `"scsi0"` | no |
| disk_iothread | Enable iothread for disk | `bool` | `true` | no |
| disk_discard | Disk discard policy | `string` | `"on"` | no |
| disk_size | Disk size in GB | `number` | `20` | no |
| disk_file_format | Disk file format | `string` | `"qcow2"` | no |
| ansible_group | Groups this host should belong to in Ansible inventory | `string` | `"vm"` | no |
| ansible_vars | Extra hostvars for Ansible inventory | `map(any)` | `{}` | no |
| ansible_hostname | Inventory hostname (defaults to vm_name) | `string` | `null` | no |
| domain | DNS domain name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ansible_host | Ansible inventory host information |
| vm_id | The ID of the created VM |

## Example Usage

```hcl
module "windows_vm" {
  source = "../modules/vm-windows"

  vm_name          = "my-windows-vm"
  node_name        = "pve1"
  clone_node_name  = "pve1"
  vlan_id          = 170
  domain           = "example.com"
  ip_address       = "172.16.0.10/24"
  gateway          = "172.16.0.1"
  password         = "MySecurePassword123!"
  disk_size        = 48
}
```

## Notes

- The VM is cloned from template ID 9001 by default.
- Initialization sets static IP if provided, otherwise DHCP.
- No SSH keys are configured; use password authentication.
- The VM uses OVMF BIOS and VirtIO hardware. 