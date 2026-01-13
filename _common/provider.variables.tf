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

variable "ssh_private_key_path" {
  description = "SSH for Proxmox"
  type = string
}