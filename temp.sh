#!/bin/bash

environment="dev"

modules_changed=$(terragrunt find --filter-affected --format json | jq .)

for module in $(echo "$modules_changed" | jq -r '.[].path' | grep "$environment" ); do
    echo "Planning module: $module"
    terragrunt run --all --json-out-dir /tmp/json plan --working-dir "$module"
    # terragrunt show -json "/tmp/plan_output_$module.tfplan" > "/tmp/plan_output_$module.json"
    # rm "/tmp/plan_output_$module.tfplan"

done

