# Module template

This folder provides the starter files used by the `create-module` recipe in [justfile](justfile).

## Included files

- [main.tf](main.tf) — basic module skeleton.
- [provider.tf](provider.tf) — placeholder provider configuration.
- [variables.tf](variables.tf) — sample input variables.

## Usage

Create a new module from this template:

````sh
just create-module my-module