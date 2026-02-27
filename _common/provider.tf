terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.93.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0"
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
<<<<<<< HEAD
    private_key = file("${var.pve_ssh_key_path}")
=======
    private_key = file("/home/peder/.ssh/pve")
>>>>>>> 3f5f32d (Update template with latest Lab-tofu changes)

  }
}