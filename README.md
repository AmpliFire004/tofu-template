# Lab-tofu

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
# 1) One-time repository setup
just setup
#    This removes existing git history, initializes fresh local git metadata,
#    and prepares
#    _common/secrets.tfvars from the example file when available.
#    It also prompts for a Git remote URL and sets it as origin.

# 2) Edit _common/secrets.tfvars and fill provider credentials.

# 3) Create a new project
just create my-project

# 4) Initialize, plan, and apply
just init my-project
just plan my-project        # writes my-project/tfplan
just apply my-project       # requires the plan file

# Auto-approve shortcut
just apply my-project+      # '+' enables -auto-approve
```

## Commands

The [justfile](justfile) defines these grouped recipes:

- [Setup] `setup`: one-time local bootstrap; removes existing `.git` history, runs `git init`, moves `_common/secrets.tfvars.example` to `_common/secrets.tfvars` when available, then prompts for a Git remote URL to set as `origin` (or skip).

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

## Quick Start

1. **Clone and setup:**
   ```bash
   git clone <repository-url>
   cd lab-tofu
   ```

2. **Configure secrets:**
   ```bash
   # Copy and edit secrets template
   cp _common/secrets.tfvars.example _common/secrets.tfvars
   # Edit with your Proxmox credentials
   ```

3. **Create a new project:**
   ```bash
   just project-create my-project
   ```

4. **Initialize and plan:**
   ```bash
   just init my-project
   just plan my-project
   just apply my-project
   ```

## Available Commands

The `justfile` provides convenient commands for managing projects:

### Project Management
- `just project-create <name>` - Create a new project directory with symlinks
- `just project-delete <name>` - Remove a project directory

### Module Management
- `just module-create <name>` - Create a new reusable module template
- `just module-delete <name>` - Remove a module

### Terraform Operations
- `just init <project>` - Initialize Terraform in a project
- `just plan <project>` - Create a plan file
- `just apply <project>` - Apply the plan (use `<project>+` for auto-approve)
- `just destroy <project>` - Destroy all resources in a project
- `just recreate <project>` - Destroy then reapply all resources with auto-approve
- `just validate <project>` - Validate configuration
- `just output <project>` - Show outputs
- `just refresh <project>` - Refresh state

### Utilities
- `just fmt` - Format all Terraform files

## Modules

### vm-linux
Creates Linux virtual machines on Proxmox by cloning from a template.

**Key Features:**
- Automated VM provisioning
- SSH key injection
- Ansible inventory generation
- Network configuration
- Disk and resource customization

See [_modules/vm-linux/README.md](_modules/vm-linux/README.md) for detailed usage.

### vm-windows
Creates Windows virtual machines on Proxmox by cloning from a template.

**Key Features:**
- Automated Windows VM provisioning
- Network configuration
- Disk and resource customization
- OVMF BIOS with VirtIO hardware
- Ansible inventory generation

See [_modules/vm-windows/README.md](_modules/vm-windows/README.md) for detailed usage.

## Configuration

### Shared Configuration (_common/)
All projects share common configuration files that are automatically symlinked:

- **Provider config**: Proxmox API connection and authentication
- **Global variables**: SSH keys, default usernames
- **Secrets**: API tokens, passwords (not committed to git)
- **Inventory generation**: Automatic Ansible inventory creation

See [_common/README.md](_common/README.md) for details.

### Project Structure
Each project directory contains:
- `main.tf` - Main Terraform configuration
- `variables.tf` - Project-specific variables
- `variables.tfvars` - Variable values
- `secrets.tfvars` - Project secrets (symlinked)
- `inventory.tf` - Ansible inventory generation (symlinked from _common/)
- `terraform.tfstate*` - State files
- Symlinks to other `_common/` files

The `inventory.tf` file automatically generates Ansible inventory files based on VM module outputs, enabling seamless integration with Ansible automation.

## Security

- Never commit `secrets.tfvars` files
- Use environment-specific secret management
- Rotate API tokens regularly
- Review Terraform plans before applying

## Contributing

1. Use modules for reusable components
2. Follow the established project structure
3. Test changes in a dedicated project before applying to production
4. Update documentation for any new features
