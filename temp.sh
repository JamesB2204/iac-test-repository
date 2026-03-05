#!/bin/bash

environment="dev"

modules_changed=$(terragrunt find --filter-affected --format json | jq .)

for module in $(echo "$modules_changed" | jq -r '.[].path' | grep "$environment" ); do
    echo "Planning module: $module"
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

done

