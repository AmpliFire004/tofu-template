set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Global shared var layers
common_dir := "_common"
global_vars := common_dir + "/global.auto.tfvars"
global_secrets := common_dir + "/secrets.tfvars"
plan_file := "tfplan"

# Tofu Commands
# Init project
[group('tofu')]
init project:
    proj="{{project}}"; cd "$proj" && tofu init

# Plan to file (requires planfile)
[group('tofu')]
plan project:
    proj="{{project}}"; pf="{{plan_file}}"; vf="-var-file=../{{global_vars}} -var-file=../{{global_secrets}} -var-file=secrets.tfvars -var-file=variables.tfvars"; cd "$proj" && tofu plan ${vf} -out="$pf"

# Apply plan file (requires existing planfile). Use project+ for auto-approve.
[group('tofu')]
apply project:
    proj="{{project}}"; auto=""; [[ "$proj" == *+ ]] && auto="-auto-approve" && proj="${proj%+}"; pf="{{plan_file}}"; [ -f "$proj/$pf" ] || { echo "Plan file '$proj/$pf' not found. Run: just plan $proj"; exit 1; }; cd "$proj" && tofu apply $auto "$pf"

# Destroy with layered var files
[group('tofu')]
destroy project:
    proj="{{project}}"; vf="-var-file=../{{global_vars}} -var-file=../{{global_secrets}} -var-file=secrets.tfvars -var-file=variables.tfvars"; cd "$proj" && tofu destroy ${vf}

# Validate configuration
[group('tofu')]
validate project:
    proj="{{project}}"; cd "$proj" && tofu validate

# Format recursively
[group('tofu')]
fmt:
    tofu fmt -recursive

# Show outputs
[group('tofu')]
output project:
    proj="{{project}}"; cd "$proj" && tofu output

# Refresh state only
[group('tofu')]
refresh project:
    proj="{{project}}"; vf="-var-file=../{{global_vars}} -var-file=../{{global_secrets}} -var-file=secrets.tfvars -var-file=variables.tfvars"; cd "$proj" && tofu apply -refresh-only ${vf}

# Project Management
[group('project')]
create-project project:
    if [ -z "{{project}}" ]; then echo "Usage: just create-project project=<name>"; exit 1; fi
    if grep -qw "{{project}}" projects.mk; then echo "Project '{{project}}' already exists in projects.mk"; exit 1; fi

    mkdir -p "{{project}}"
    ln -sfn ../_common/common.variables.tf "{{project}}/common.variables.tf"
    ln -sfn ../_common/provider.tf "{{project}}/provider.tf"
    ln -sfn ../_common/provider.variables.tf "{{project}}/provider.variables.tf"
    touch "{{project}}/main.tf"
    touch "{{project}}/secrets.tfvars"
    touch "{{project}}/variables.tf"
    echo "# optional per-project vars" > "{{project}}/variables.tfvars"

    echo "PROJECTS += {{project}}" >> projects.mk
    echo "Created project '{{project}}' and registered it"

[group('project')]
delete project:
    [ -z "{{project}}" ] && echo "Usage: just delete <name>" && exit 1; if ! grep -qw "{{project}}" projects.mk; then echo "Project '{{project}}' not found in projects.mk"; exit 1; fi; read -p "Are you sure you want to delete project '{{project}}' and its files? (yes/no): " ans; if [ "$ans" != "yes" ]; then echo "Aborted."; exit 1; fi; echo "Removing project directory '{{project}}'..."; rm -rf "{{project}}"; echo "Unregistering project from projects.mk..."; sed -i '' '/PROJECTS += {{project}}/d' projects.mk || true; echo "Deleted project '{{project}}'"
