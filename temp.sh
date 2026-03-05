#!/bin/bash

environment="dev"

git checkout develop

modules_changed=$(terragrunt find --filter-affected --format json | jq .)

git checkout main

for module in $(echo "$modules_changed" | jq -r '.[].path' | grep "$environment" ); do
    if [ -d "$module" ]; then
        echo "Module $module exists. Planning module: $module"
        terragrunt run --all --json-out-dir /tmp/json plan --working-dir "$module" -out-dir /tmp/tfplan
        # terragrunt show -json "/tmp/plan_output_$module.tfplan" > "/tmp/plan_output_$module.json"
        # rm "/tmp/plan_output_$module.tfplan"
        grab_json_body=$(jq -r '.resource_changes[] | select(.change.actions | index("no-op") | not) | "\(.address) → actions: \(.change.actions | join(", "))" ' /tmp/json/tfplan.json)    
        actions=$( jq -r '.resource_changes[].change.actions' /tmp/json/tfplan.json) 
        echo $actions
        for action in $( echo $actions | jq -r '.[]'); do
            if [[ "$action" == "no-op" ]]; then
                echo $action
                echo "No changes for module: $module"
            else
            echo $action
                echo "Changes detected for module: $module"
                echo "Resources with changes: $grab_json_body"
            fi
        done
    else
        echo "Module $module does not exist in higher environment. Skipping."

        continue
    fi
done

git checkout develop
