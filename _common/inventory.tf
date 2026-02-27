locals {
  # Add/remove module outputs here as you add VMs in this project
  inv_hosts = [
    # module.vm.ansible_host,
  ]

  # Flatten all groups across hosts (each host has groups = ["guacamole"] etc)
  groups = toset(flatten([for h in local.inv_hosts : try(h.groups, [])]))

  inv_yaml = yamlencode({
    all = {
      children = {
        linux = {
          children = {
            for g in local.groups : g => {
              hosts = {
                for h in local.inv_hosts :
                h.hostname => merge(
                  { ansible_host = h.ansible_host },
                  try(h.vars, {})   # include host vars if you want
                )
                if contains(try(h.groups, []), g)
              }
            }
          }
        }
      }
    }
  })
}

resource "local_file" "inventory" {
  filename = "${path.module}/"
  content  = local.inv_yaml
}
