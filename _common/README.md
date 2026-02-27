# _common Directory

This directory contains shared Terraform configuration files that are used across all projects in the Lab-tofu workspace. These files are symlinked into each project directory to ensure consistency and avoid duplication.

## Files

### common.variables.tf
Defines common variables that are shared across multiple projects, such as:
- `ssh_keys`: List of SSH public key file paths
- `vm_password`: Password for VM users
- `vm_username`: Default username for VMs

### global.auto.tfvars
Contains global auto-loaded variables that are automatically applied to all projects:
- SSH keys to be added to VMs
- Default VM username

### provider.tf
Configures the required Terraform providers:
- Proxmox provider for VM management
- Local provider for file operations

### provider.variables.tf
Defines variables specific to the Proxmox provider configuration, such as API endpoints and authentication tokens.

### secrets.tfvars
Contains sensitive variables that should not be committed to version control:
- Proxmox API tokens
- VM passwords
- Other secrets

**Note:** This file is typically not committed to git and should be created locally.

### inventory.tf
Contains logic for generating Ansible inventory files from Terraform outputs. This allows automatic generation of Ansible inventory when VMs are created.

## Usage

When creating a new project using `just project-create <name>`, these files are automatically symlinked into the new project directory. The project can then reference these shared variables and configurations.

## Security Note

Be careful with the `secrets.tfvars` file - it contains sensitive information and should never be committed to version control. Consider using a secrets management solution for production environments.