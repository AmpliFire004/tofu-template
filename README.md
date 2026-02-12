# tofu-template

Template for managing Terraform/Tofu projects with shared configuration in `_common` and per-project folders (e.g., `pve`). The repository now uses [just](https://github.com/casey/just) instead of a Makefile, and does not use `projects.mk`.

## Overview

- `_common/` — shared Terraform code and variables used across projects.
- `pve/` — for Snippet managment in PVE
- `justfile` — command runner for all project and module actions.

## Requirements

- Install `just` (macOS): `brew install just`
- Install `tofu` (Terraform fork) per your environment.

## Quick Start

```sh
# 1) Create provider-level secrets shared by all projects
#    If an example exists, copy it; otherwise create the file.
cp _common/secrets.tfvars.example _common/secrets.tfvars 2>/dev/null || :
#    Edit _common/secrets.tfvars and fill provider credentials.

# 2) Create a new project
just create my-project

# 3) Initialize, plan, and apply
just init my-project
just plan my-project        # writes my-project/tfplan
just apply my-project       # requires the plan file

# Auto-approve shortcut
just apply my-project+      # '+' enables -auto-approve
```

## Commands

The [justfile](justfile) defines these grouped recipes:

- [tofu] `init project`: initialize a project.
- [tofu] `plan project`: create a plan file `tfplan` with layered var files.
- [tofu] `apply project`: apply the existing `tfplan` (fails if missing). Supports `project+` for auto-approve.
- [tofu] `destroy project`: destroy with layered var files.
- [tofu] `validate project`: validate configuration.
- [tofu] `fmt`: format recursively.
- [tofu] `output project`: show outputs.
- [tofu] `refresh project`: refresh state only.

- [Project] `create project`: scaffold a new project directory and link `_common` files.
- [Project] `delete project`: delete a project directory (prompts for confirmation). Checks the filesystem only.

- [Module] `create-module name`: scaffold `_module/<name>` with `main.tf`, `provider.tf`, `variables.tf` from `_module/_template/`.
- [Module] `delete-module name`: delete `_module/<name>` (prompts for confirmation).

## Secrets & Variables

- Provider-level secrets (common to all projects): ensure [_common/secrets.tfvars](_common/secrets.tfvars) exists locally and contains provider authentication (e.g., tokens, usernames, passwords). This file is ignored by Git and used by every project.
- Per-project secrets: `secrets.tfvars` is created in each project by `create`. Fill per-project secrets there; it remains ignored by Git.
- Non-secret variables: edit per-project `variables.tfvars` for module inputs.
- Variable layering order used by recipes:
  1. `_common/global.auto.tfvars`
  2. `_common/secrets.tfvars`
  3. `<project>/secrets.tfvars`
  4. `<project>/variables.tfvars`

## Notes

- `apply` requires a plan file named `tfplan` in the project directory; run `just plan <project>` first.
- The workflow no longer uses `projects.mk`; recipes check the filesystem (presence of project folders) only.
- The repository’s `.gitignore` ignores `**/secrets.tfvars` everywhere.

See `_common/README.md` and `pve/README.md` for project-specific notes.