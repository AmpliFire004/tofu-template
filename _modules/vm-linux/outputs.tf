output "ansible_host" {
  value = {
    hostname     = var.vm_name
    ansible_host = "${var.vm_name}.${var.domain}"
    groups       = try([var.ansible_group], [])
    vars         = merge(
      { ansible_user = var.username },
      try(var.ansible_vars, {})
    )
  }
}


output "vm_id" {
  value = proxmox_virtual_environment_vm.vm.vm_id
}
