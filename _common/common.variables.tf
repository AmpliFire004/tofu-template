variable "ssh_keys" {
  description = "List of SSH public key file paths to be added to the VM."
  type        = list(string)
}
variable "vm_password" {
  description = "Password for the VM user."
  type        = string
  sensitive   = true
}   
variable "vm_username" {
  description = "Username for the VM user."
  type        = string
  default     = "eostest"
}
