variable "pve_api_url" {
  description = "Proxmox API URL."
  type        = string
}

variable "pve_token_id" {
  description = "Proxmox api token ID."
  type        = string
}

variable "pve_token_secret" {
  description = "Proxmox api token secret."
  type        = string
  sensitive   = true
}
variable "pve_ssh_user" {
  description = "SSH username for Proxmox."
  type        = string
}
variable "pve_ssh_key_path" {
  description = "SSH for Proxmox"
  type = string
}
