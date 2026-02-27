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

<<<<<<< HEAD
variable "pve_ssh_key_path" {
  description = "SSH for Proxmox"
  type = string
}
=======
>>>>>>> 3f5f32d (Update template with latest Lab-tofu changes)
