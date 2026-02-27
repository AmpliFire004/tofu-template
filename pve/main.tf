locals {
  nodes         = ["pve1", "pve2"]
  snippets_dir  = "${path.module}/snippets"
  snippet_files = fileset(local.snippets_dir, "*") # add "**/*" if you want subfolders too

  uploads = {
    for pair in setproduct(toset(local.nodes), toset(local.snippet_files)) :
    "${pair[0]}:${pair[1]}" => {
      node = pair[0]
      file = pair[1]
      path = "${local.snippets_dir}/${pair[1]}"
    }
  }
}

resource "proxmox_virtual_environment_file" "snippets" {
  for_each = local.uploads

  node_name    = each.value.node
  datastore_id = "local"
  content_type = "snippets"

  source_file {
    path = each.value.path
  }
}
