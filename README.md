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

## Using Just

You can use [justfile](justfile) as a friendly command runner equivalent to the Make targets.

- General form:
  - `PROJECT=<project> just <target>` — use `PROJECT` env var.
  - `just <target> project=<project>` — pass the project as a recipe arg.

Common recipes (from [justfile](justfile)):

- `help` — show usage.
- `init` — runs `tofu init` in the project dir.
- `plan` — runs `tofu plan` with layered var files.
- `apply` — runs `tofu apply` with layered var files.
- `applya` — `apply` with `-auto-approve`.
- `destroy` — runs `tofu destroy`.
- `validate` — runs `tofu validate`.
- `fmt` — runs `tofu fmt -recursive`.
- `output` — shows `tofu output` for a project.
- `refresh` — runs `tofu apply -refresh-only`.
- `create-project` — scaffolds a new project and links `_common` files.
- `delete-project` — deletes a project and unregisters it from [projects.mk](projects.mk).

Examples:

```sh
# Using env var
PROJECT=pve just plan

# Passing arg
just apply <project>

# Create / delete
just create-project <project>
just delete-project <project>
```

## Secrets & Variables

- Provider-level secrets (common to all projects): after cloning, ensure [_common/secrets.tfvars](_common/secrets.tfvars) exists locally. Copy the repo’s example (if present) or create the file, and fill provider authentication details (e.g., cloud/proxmox tokens, usernames, passwords). This file is ignored by Git and used by every project.
- Per-project secrets: are created automatically by `create-project` and should be filled per project . These remain ignored by Git.
- Non-secret variables: create or update per project with non-secret inputs for your modules.
- Workflow with Just:
  - `just plan <project>` — generates a plan file inside the project.
  - `just apply <project>` — applies the previously generated plan; fails if no plan file exists.

Tip: DO not manually edit [projects.mk](projects.mk) so commands like `just init <project>` work smoothly.