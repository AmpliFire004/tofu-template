set shell := ["bash", "-eu", "-o", "pipefail", "-c"]
set quiet := true

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

# Plan to file 
[group('tofu')]
plan project:
    proj="{{project}}"; pf="{{plan_file}}"; vf="-var-file=../{{global_vars}} -var-file=../{{global_secrets}} -var-file=secrets.tfvars -var-file=variables.tfvars"; cd "$proj" && tofu plan ${vf} -out="$pf"

# Apply plan file.
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

# Create new project
[group('Project')]
create project:
    # Check filesystem, not projects.mk
    if [ -d "{{project}}" ]; then echo "Project '{{project}}' already exists at ./{{project}}"; exit 1; fi
    mkdir -p "{{project}}"
    ln -sfn ../_common/common.variables.tf "{{project}}/common.variables.tf"
    ln -sfn ../_common/provider.tf "{{project}}/provider.tf"
    ln -sfn ../_common/provider.variables.tf "{{project}}/provider.variables.tf"
    touch "{{project}}/main.tf"
    touch "{{project}}/secrets.tfvars"
    touch "{{project}}/variables.tf"
    echo "# optional per-project vars" > "{{project}}/variables.tfvars"
    echo "Created project '{{project}}'"
# Delete existing project
[group('Project')]
delete project:
    [ -z "{{project}}" ] && echo "Usage: just delete <name>" && exit 1; if [ ! -d "{{project}}" ]; then echo "Project '{{project}}' not found at ./{{project}}"; exit 1; fi; read -p "Are you sure you want to delete project '{{project}}' and its files? (yes/no): " ans; if [ "$ans" != "yes" ]; then echo "Aborted."; exit 1; fi; echo "Removing project directory '{{project}}'..."; rm -rf "{{project}}"; echo "Deleted project '{{project}}'"
# Create new module
[group('Module')]
create-module name:
    if [ -d "_modules/{{name}}" ]; then echo "Module '{{name}}' already exists at _modules/{{name}}"; exit 1; fi
    mkdir -p "_modules/{{name}}"
    touch "_modules/{{name}}/main.tf"
    touch "_modules/{{name}}/variables.tf"
    touch "_modules/{{name}}/outputs.tf"
    touch "_modules/{{name}}/README.md"
    echo "# Module '{{name}}'" > "_modules/{{name}}/README.md"
    echo "Created module '{{name}}' at _modules/{{name}}"
# Delete existing module
[group('Module')]
delete-module name:
    dir="_modules/{{name}}"; if [ ! -d "$dir" ]; then echo "Module '{{name}}' not found at $dir"; exit 1; fi; read -p "Are you sure you want to delete module '{{name}}' at $dir? (yes/no): " ans; if [ "$ans" != "yes" ]; then echo "Aborted."; exit 1; fi; rm -rf "$dir"; echo "Deleted module at $dir"

# Initial setup of this repository, including git and secrets.tfvars
[group('Setup')]
setup:
    rm -rf .git
    git init
    mv _common/secrets.tfvars.example _common/secrets.tfvars 2>/dev/null || true
    read -r -p "Enter git remote URL for origin (leave empty to skip): " remote_url
    if [ -n "$remote_url" ]; then
        git remote add origin "$remote_url"
        echo "Set git remote 'origin' to $remote_url"
    else
        echo "Skipped setting git remote 'origin'."
    fi
    echo "Removed git history, initialized a fresh repository, and prepared secrets.tfvars under _common."