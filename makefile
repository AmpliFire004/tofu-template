SHELL := /usr/bin/env bash
# Load known projects
include projects.mk


# Which subproject to run (folder). Usage: make pve apply  OR  make PROJECT=pve apply
PROJECT ?= pve

# Global shared var layers
COMMON_DIR     := _common
GLOBAL_VARS    := $(COMMON_DIR)/global.auto.tfvars
GLOBAL_SECRETS := $(COMMON_DIR)/secrets.tfvars

# Per-project secrets (can be overridden)
PROJECT_SECRETS ?= secrets.tfvars
PROJECT_VARS ?= variables.tfvars

# Assemble layered var-file args (later overrides earlier)
VAR_FILES := -var-file=../$(GLOBAL_VARS) -var-file=../$(GLOBAL_SECRETS) -var-file=$(PROJECT_SECRETS) -var-file=$(PROJECT_VARS)
.DEFAULT_GOAL := help
.PHONY: help init plan apply applya destroy validate fmt output refresh create-project delete-project

SUBDIRS := $(PROJECTS)
FIRST := $(firstword $(MAKECMDGOALS))

help:
	@echo "Usage:"
	@echo "  make <project> <target>"
	@echo ""
	@echo "Registered projects:"
	@for p in $(PROJECTS); do echo "  - $$p"; done
	@echo ""
	@echo "Targets: init plan apply applya destroy validate fmt output refresh create-project delete-project"


# If the first goal is a subdir (e.g. `make pve init`), we want the subdir
# target to invoke the command in that folder and NOT run the top-level
# commands again. When FIRST is one of SUBDIRS we provide no-op recipes for
# the top-level actions to avoid duplicate/extra runs.
ifeq ($(filter $(FIRST),$(SUBDIRS)),)

init:
	cd $(PROJECT) && tofu init

plan:
	cd $(PROJECT) && tofu plan $(VAR_FILES)

apply:
	cd $(PROJECT) && tofu apply $(VAR_FILES)

applya:
	cd $(PROJECT) && tofu apply $(VAR_FILES) -auto-approve

destroy:
	cd $(PROJECT) && tofu destroy $(VAR_FILES)

validate:
	cd $(PROJECT) && tofu validate

fmt:
	tofu fmt -recursive

output:
	cd $(PROJECT) && tofu output

refresh:
	cd $(PROJECT) && tofu apply -refresh-only $(VAR_FILES)

else

init plan apply applya destroy validate fmt output refresh:
	@:

endif

CMD := $(filter-out $(PROJECTS),$(MAKECMDGOALS))

# Dynamically generate a phony target for each project listed in projects.mk.
# Each project target forwards remaining make goals into the project's folder.
ifeq ($(strip $(PROJECTS)),)
# no projects registered; nothing to generate
else
define make-proj
.PHONY: $(1)
$(1):
	@$(MAKE) PROJECT=$(1) $(CMD)
	@:
endef
$(foreach p,$(PROJECTS),$(eval $(call make-proj,$p)))
endif

# swallow extra words / goals so outer make doesn't run them again
%:
	@:

# Create a new project folder and symlink common files
.PHONY: create-project
create-project:
	@if [ -z "$(PROJECT)" ]; then echo "Usage: make create-project PROJECT=<name>"; exit 1; fi
	@if grep -qw "$(PROJECT)" projects.mk; then echo "Project '$(PROJECT)' already exists in projects.mk"; exit 1; fi

	mkdir -p $(PROJECT)
	ln -sfn ../_common/common.variables.tf $(PROJECT)/common.variables.tf
	ln -sfn ../_common/provider.tf $(PROJECT)/provider.tf
	ln -sfn ../_common/provider.variables.tf $(PROJECT)/provider.variables.tf
	touch $(PROJECT)/main.tf
	touch $(PROJECT)/secrets.tfvars
	touch $(PROJECT)/variables.tf
	echo "# optional per-project vars" > $(PROJECT)/variables.tfvars

	@echo "PROJECTS += $(PROJECT)" >> projects.mk
	@echo "Created project '$(PROJECT)' and registered it"


.PHONY: delete-project
delete-project:
	@if [ -z "$(PROJECT)" ]; then echo "Usage: make delete-project PROJECT=<name>"; exit 1; fi
	@if ! grep -qw "$(PROJECT)" projects.mk; then echo "Project '$(PROJECT)' not found in projects.mk"; exit 1; fi

	@read -p "Are you sure you want to delete project '$(PROJECT)' and its files? (yes/no): " ans && \
	if [ "$$ans" != "yes" ]; then echo "Aborted."; exit 1; fi

	@echo "Removing project directory '$(PROJECT)'..."
	@rm -rf $(PROJECT)
	@echo "Unregistering project from projects.mk..."
	@sed -i '/PROJECTS += $(PROJECT)/d' projects.mk || true
	@echo "Deleted project '$(PROJECT)'"
