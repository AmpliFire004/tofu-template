# _common

Files in this folder are shared among all projects in the repository.

- `common.variables.tf` — variables shared by projects.
- `provider.tf` — provider configuration used by projects.
- `provider.variables.tf` — provider-related variables.
- `global.auto.tfvars` — global variable values (loaded automatically).
- `secrets.tfvars` — global secrets (not recommended to commit sensitive values).

How to use

- The top-level `Makefile` symlinks the necessary `_common` files into each
  project folder when using `make create-project`.
- Per-project variables and secrets live inside each project directory and
  override shared values.

Keep sensitive values out of source control and prefer environment-based
secrets or CI-managed secret stores where appropriate.