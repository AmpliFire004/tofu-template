locals {
  nodes = ["pve1", "pve2"]
}

resource "proxmox_virtual_environment_file" "postclone" {
  for_each = toset(local.nodes)

  node_name    = each.value
  datastore_id = "local"
  content_type = "snippets"

  source_file {
    path = "${path.module}/snippets/postclone.yml"
  }
}

