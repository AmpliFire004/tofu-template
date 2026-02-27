# PVE project

Purpose

- Manage reusable Proxmox VE snippets and small automations.
- Serve as an example Terraform/Tofu project in this repository.

Structure

- `Snippets/` — small configuration snippets and automation examples.
- `postclone.yml` — optional automation run after cloning a project.

Usage

- Initialize, plan, and apply:
  - `just init pve`
  - `just plan pve`   (writes `pve/tfplan`)
  - `just apply pve`  (requires `tfplan`; use `pve+` for auto-approve)

- Other helpful recipes:
  - `just destroy pve`
  - `just validate pve`
  - `just output pve`

Notes

- Ensure shared provider secrets exist at `_common/secrets.tfvars`.
- Fill per-project secrets at `pve/secrets.tfvars` as needed.
- Keep snippets modular, documented, and focused on PVE-specific tasks.