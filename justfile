set shell := ["bash", "-eu", "-o", "pipefail", "-c"]
<<<<<<< HEAD

# Global shared var layers
=======
set quiet

# Global shared var layers
root_dir := "/home/peder/adm/Infra/Lab-tofu"
>>>>>>> 3f5f32d (Update template with latest Lab-tofu changes)
common_dir := "_common"
global_vars := common_dir + "/global.auto.tfvars"
global_secrets := common_dir + "/secrets.tfvars"
plan_file := "tfplan"

# Tofu Commands
# Init project
[group('tofu')]
init project:
<<<<<<< HEAD
    proj="{{project}}"; cd "$proj" && tofu init
=======
    proj="{{project}}"; cd "{{root_dir}}/$proj" && tofu init
>>>>>>> 3f5f32d (Update template with latest Lab-tofu changes)

# Plan to file 
[group('tofu')]
plan project:
<<<<<<< HEAD
    proj="{{project}}"; pf="{{plan_file}}"; vf="-var-file=../{{global_vars}} -var-file=../{{global_secrets}} -var-file=secrets.tfvars -var-file=variables.tfvars"; cd "$proj" && tofu plan ${vf} -out="$pf"
=======
    proj="{{project}}"; pf="{{plan_file}}"; vf="-var-file=../{{global_vars}} -var-file=../{{global_secrets}} -var-file=secrets.tfvars -var-file=variables.tfvars"; cd "{{root_dir}}/$proj" && tofu plan ${vf} -out="$pf"
>>>>>>> 3f5f32d (Update template with latest Lab-tofu changes)

# Apply plan file.
[group('tofu')]
apply project:
<<<<<<< HEAD
    proj="{{project}}"; auto=""; [[ "$proj" == *+ ]] && auto="-auto-approve" && proj="${proj%+}"; pf="{{plan_file}}"; [ -f "$proj/$pf" ] || { echo "Plan file '$proj/$pf' not found. Run: just plan $proj"; exit 1; }; cd "$proj" && tofu apply $auto "$pf"
=======
    proj="{{project}}"; auto=""; \
    [[ "$proj" == *+ ]] && auto="-auto-approve" && proj="${proj%+}"; \
    pf="{{plan_file}}"; \
    [ -f "{{root_dir}}/$proj/$pf" ] || { echo "Plan file '{{root_dir}}/$proj/$pf' not found. Run: just plan $proj"; exit 1; }; \
    cd "{{root_dir}}/$proj" && \
    tofu apply $auto "$pf" && \
    rm -f "$pf"

>>>>>>> 3f5f32d (Update template with latest Lab-tofu changes)

# Destroy with layered var files
[group('tofu')]
destroy project:
<<<<<<< HEAD
    proj="{{project}}"; vf="-var-file=../{{global_vars}} -var-file=../{{global_secrets}} -var-file=secrets.tfvars -var-file=variables.tfvars"; cd "$proj" && tofu destroy ${vf}
=======
    proj="{{project}}"; vf="-var-file=../{{global_vars}} -var-file=../{{global_secrets}} -var-file=secrets.tfvars -var-file=variables.tfvars"; cd "{{root_dir}}/$proj" && tofu destroy ${vf}
>>>>>>> 3f5f32d (Update template with latest Lab-tofu changes)

# Validate configuration
[group('tofu')]
validate project:
<<<<<<< HEAD
    proj="{{project}}"; cd "$proj" && tofu validate
=======
    proj="{{project}}"; cd "{{root_dir}}/$proj" && tofu validate
>>>>>>> 3f5f32d (Update template with latest Lab-tofu changes)

# Format recursively
[group('tofu')]
fmt:
    tofu fmt -recursive

# Show outputs
[group('tofu')]
output project:
<<<<<<< HEAD
    proj="{{project}}"; cd "$proj" && tofu output
=======
    proj="{{project}}"; cd "{{root_dir}}/$proj" && tofu output
>>>>>>> 3f5f32d (Update template with latest Lab-tofu changes)

# Refresh state only
[group('tofu')]
refresh project:
<<<<<<< HEAD
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
    if [ -d "_module/{{name}}" ]; then echo "Module '{{name}}' already exists at _module/{{name}}"; exit 1; fi
    mkdir -p "_module/{{name}}"
    cp "_module/_template/main.tf" "_module/{{name}}/main.tf"
    cp "_module/_template/provider.tf" "_module/{{name}}/provider.tf"
    cp "_module/_template/variables.tf" "_module/{{name}}/variables.tf"
    echo "Created module at _module/{{name}} with main.tf, provider.tf, variables.tf"
# Delete existing module
[group('Module')]
delete-module name:
    dir="_module/{{name}}"; if [ ! -d "$dir" ]; then echo "Module '{{name}}' not found at $dir"; exit 1; fi; read -p "Are you sure you want to delete module '{{name}}' at $dir? (yes/no): " ans; if [ "$ans" != "yes" ]; then echo "Aborted."; exit 1; fi; rm -rf "$dir"; echo "Deleted module at $dir"
=======
    proj="{{project}}"; vf="-var-file=../{{global_vars}} -var-file=../{{global_secrets}} -var-file=secrets.tfvars -var-file=variables.tfvars"; cd "{{root_dir}}/$proj" && tofu apply -refresh-only ${vf}

# Recreate all resources (destroy then apply with auto-approve)
[group('tofu')]
recreate project:
    proj="{{project}}"; vf="-var-file=../{{global_vars}} -var-file=../{{global_secrets}} -var-file=secrets.tfvars -var-file=variables.tfvars"; echo "Recreating resources in project '{{project}}'..."; cd "{{root_dir}}/$proj" && tofu destroy -auto-approve ${vf} >/dev/null 2>&1 && tofu apply -auto-approve ${vf} >/dev/null 2>&1 && echo "Successfully recreated all resources in project '{{project}}'"

# Create new project
[group('project')]
project-create name:
    if [ -z "{{name}}" ]; then echo "Usage: just project-create <name>"; exit 1; fi
    if [ -d "{{root_dir}}/{{name}}" ]; then echo "Project '{{name}}' already exists"; exit 1; fi

    mkdir -p "{{root_dir}}/{{name}}"
    ln -sfn "{{root_dir}}/_common/common.variables.tf" "{{root_dir}}/{{name}}/common.variables.tf"
    ln -sfn "{{root_dir}}/_common/provider.tf" "{{root_dir}}/{{name}}/provider.tf"
    ln -sfn "{{root_dir}}/_common/provider.variables.tf" "{{root_dir}}/{{name}}/provider.variables.tf"
    [ -e "{{root_dir}}/{{name}}/inventory.tf" ] || cp "{{root_dir}}/_common/inventory.tf" "{{root_dir}}/{{name}}/inventory.tf"
    touch "{{root_dir}}/{{name}}/main.tf"
    touch "{{root_dir}}/{{name}}/secrets.tfvars"
    touch "{{root_dir}}/{{name}}/variables.tf"
    echo "# optional per-project vars" > "{{root_dir}}/{{name}}/variables.tfvars"

    echo "Created project '{{name}}' and registered it"
# Delete existing project
[group('project')]
project-delete name:
    [ -z "{{name}}" ] && echo "Usage: just project-delete <name>" && exit 1; if [ ! -d "{{root_dir}}/{{name}}" ]; then echo "Project '{{name}}' does not exist"; exit 1; fi; read -p "Are you sure you want to delete project '{{name}}' and its files? (yes/no): " ans; if [ "$ans" != "yes" ]; then echo "Aborted."; exit 1; fi; echo "Removing project directory '{{name}}'..."; rm -rf "{{root_dir}}/{{name}}"; echo "Unregistering project from projects.mk...";  true; echo "Deleted project '{{name}}'"

# Create template module
[group('modules')]
module-create name:
    if [ -z "{{name}}" ]; then echo "Usage: just module-create <module_name>"; exit 1; fi
    mkdir -p "{{root_dir}}/_modules/{{name}}"
    echo "# Module: {{name}}" > "{{root_dir}}/_modules/{{name}}/main.tf"
    echo 'variable "example" {' > "{{root_dir}}/_modules/{{name}}/variables.tf"
    echo '  description = "An example variable"' >> "{{root_dir}}/_modules/{{name}}/variables.tf"
    echo '  type = string' >> "{{root_dir}}/_modules/{{name}}/variables.tf"
    echo '  default = "default"' >> "{{root_dir}}/_modules/{{name}}/variables.tf"
    echo '}' >> "{{root_dir}}/_modules/{{name}}/variables.tf"
    echo "# {{name}}" > "{{root_dir}}/_modules/{{name}}/README.md"
    echo "" >> "{{root_dir}}/_modules/{{name}}/README.md"
    echo "This is a Terraform module." >> "{{root_dir}}/_modules/{{name}}/README.md"
    echo "" >> "{{root_dir}}/_modules/{{name}}/README.md"
    echo "## Usage" >> "{{root_dir}}/_modules/{{name}}/README.md"
    echo "" >> "{{root_dir}}/_modules/{{name}}/README.md"
    echo 'module "{{name}}" {' >> "{{root_dir}}/_modules/{{name}}/README.md"
    echo '  source = "../_modules/{{name}}"' >> "{{root_dir}}/_modules/{{name}}/README.md"
    echo '  # variables' >> "{{root_dir}}/_modules/{{name}}/README.md"
    echo '}' >> "{{root_dir}}/_modules/{{name}}/README.md"
    echo "Created template module '{{name}}'"

# Delete template module
[group('modules')]
module-delete name:
    [ -z "{{name}}" ] && echo "Usage: just module-delete <name>" && exit 1; if [ ! -d "{{root_dir}}/_modules/{{name}}" ]; then echo "Module '{{name}}' does not exist"; exit 1; fi; read -p "Are you sure you want to delete module '{{name}}' and its files? (yes/no): " ans; if [ "$ans" != "yes" ]; then echo "Aborted."; exit 1; fi; echo "Removing module directory '_modules/{{name}}'..."; rm -rf "{{root_dir}}/_modules/{{name}}"; echo "Deleted module '{{name}}'"
>>>>>>> 3f5f32d (Update template with latest Lab-tofu changes)
