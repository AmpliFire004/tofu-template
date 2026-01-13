terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.93.0"
    }
  }
}

provider "proxmox" {
  # Configure your Proxmox provider connection here
  endpoint     = var.pve_api_url
  api_token = "${var.pve_token_id}=${var.pve_token_secret}"
  ssh {
    agent = false
    username = "root"
    private_key = file("${var.ssh_private_key_path}")

  }
}