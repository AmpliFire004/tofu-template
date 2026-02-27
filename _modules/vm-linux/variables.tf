variable "vm_name" {
  description = "Name of the VM."
  type        = string
}

variable "node_name" {
  description = "Proxmox node name where the VM will be created."
  type        = string
}

variable "description" {
  description = "Description of the VM."
  type        = string
  default     = "VM created with Terraform"
}

variable "protection" {
  description = "Whether the VM is protected."
  type        = bool
  default     = false
}

variable "on_boot" {
  description = "Whether the VM starts on boot."
  type        = bool
  default     = false
}

variable "clone_vm_id" {
  description = "VM ID of the template to clone from."
  type        = number
  default     = 9000
}

variable "clone_node_name" {
  description = "Node name where the template is located."
  type        = string
}

variable "cpu_cores" {
  description = "Number of CPU cores."
  type        = number
  default     = 4
}

variable "memory_dedicated" {
  description = "Dedicated memory in MB."
  type        = number
  default     = 4096
}

variable "bridge" {
  description = "Network bridge."
  type        = string
  default     = "LabServer"
}

variable "vlan_id" {
  description = "VLAN ID for the network."
  type        = number
}

variable "vendor_data_file_id" {
  description = "Vendor data file ID."
  type        = string
  default     = "local:snippets/postclone.yml"
}

variable "datastore_id" {
  description = "Datastore ID for initialization."
  type        = string
  default     = "msa_lvm"
}

variable "ip_address" {
  description = "IP address for the VM."
  type        = string
}

variable "gateway" {
  description = "Gateway IP address."
  type        = string
  default     = null
}

variable "username" {
  description = "Username for the VM user."
  type        = string
  default     = "eostest"
}

variable "password" {
  description = "Password for the VM user."
  type        = string
}

variable "ssh_keys" {
  description = "List of SSH public keys."
  type        = list(string)
}

variable "efi_datastore_id" {
  description = "Datastore ID for EFI disk."
  type        = string
  default     = "msa_lvm"
}

variable "disk_datastore_id" {
  description = "Datastore ID for the disk."
  type        = string
  default     = "msa_lvm"
}

variable "disk_interface" {
  description = "Disk interface."
  type        = string
  default     = "scsi0"
}

variable "disk_iothread" {
  description = "Enable iothread for disk."
  type        = bool
  default     = true
}

variable "disk_discard" {
  description = "Disk discard policy."
  type        = string
  default     = "on"
}

variable "disk_size" {
  description = "Disk size in GB."
  type        = number
  default     = 20
}

variable "disk_file_format" {
  description = "Disk file format."
  type        = string
  default     = "qcow2"
}
variable "ansible_group" {
  description = "Groups this host should belong to in Ansible inventory"
  type        = string
  default     = "vm"
}

variable "ansible_vars" {
  description = "Extra hostvars for Ansible inventory"
  type        = map(any)
  default     = {}
}

variable "ansible_hostname" {
  description = "Inventory hostname (defaults to vm_name)"
  type        = string
  default     = null
}
variable "domain" {
  description = "DNS domain name"
  type        = string
}
