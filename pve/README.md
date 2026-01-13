# PVE project

This folder contains the `pve` project used as an example for managing
Proxmox VE resources and for storing reusable snippets.

Structure

- `Snippets/` — small configuration snippets and automation examples.
- `postclone.yml` — automation run after cloning a project (if used).

Usage

- Run a Makefile target for this project, for example:

  - `make pve plan`
  - `make pve apply`

  Alternatively set the `PROJECT` variable and run a target:

  - `make PROJECT=pve apply`

Snippets are intended as examples and utilities to bootstrap or configure
resources; keep them modular and documented.