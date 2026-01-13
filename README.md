# tofu-template

Repository template for managing Terraform-based projects. Organizes shared
configuration in `_common` and per-project folders (for example `pve`).

Quick overview

- `_common/` — shared Terraform code and variables used across projects.
- `pve/` — example project (Proxmox VE), contains `Snippets/` and helpers.
- `projects.mk` — registered projects list.
- `makefile` — top-level helpers to run `tofu` commands per project.

Using the Makefile

General form:

- `make <project> <target>` — run `<target>` for the named project (e.g. `make pve plan`).
- `make PROJECT=<project> <target>` — alternative form.

Common targets (from `makefile`):

- `help` — show usage and registered projects.
- `init` — initialize the project (runs `tofu init` in project dir).
- `plan` — run `tofu plan` with layered var files.
- `apply` — run `tofu apply` with layered var files.
- `applya` — `apply` with `-auto-approve`.
- `destroy` — run `tofu destroy`.
- `validate` — run `tofu validate`.
- `fmt` — run `tofu fmt -recursive`.
- `output` — show `tofu output` for a project.
- `refresh` — run `tofu apply -refresh-only`.
- `create-project` — scaffold a new project and symlink `_common` files.
- `delete-project` — delete a project directory and unregister it.

Create / Delete projects

- `make create-project PROJECT=<name>` — scaffold a new project directory named
  `<name>`, create placeholder `main.tf`, `secrets.tfvars` and `variables.tfvars`,
  and symlink shared files from `_common/`. The new project is added to
  `projects.mk`.

- `make delete-project PROJECT=<name>` — remove the project directory and
  unregister it from `projects.mk`. This target prompts for confirmation;
  run it only when you intend to permanently delete the project's files.

Examples:

```
make create-project PROJECT=myproject
make PROJECT=myproject apply
make delete-project PROJECT=myproject
```

Notes

- Shared variables are assembled using `global.auto.tfvars`, per-project
  `secrets.tfvars`, and per-project `variables.tfvars` in that order (later
  files override earlier ones).
- `projects.mk` holds the `PROJECTS` list used by the Makefile.

See `_common/README.md` and `pve/README.md` for project-specific notes.