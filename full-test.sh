#!/bin/bash

set -eo pipefail

# Format and validate Terraform configuration
pre_deployment() {
    echo "Formatting Terraform..."
    terraform fmt -recursive || { echo "Terraform formatting failed!"; exit 1; }

    echo "Validating Terraform..."
    terraform validate || { echo "Terraform validation failed!"; exit 1; }
}

# Deploy infrastructure resources
deploy() {
    echo "Deploying Infrastructure Resources..."
    if ! terraform apply -compact-warnings -auto-approve; then
        echo "Deployment Failed!"
        echo "Destroying resources due to deployment failure..."
        terraform destroy -compact-warnings -auto-approve || echo "Resource destruction failed during cleanup."
        exit 1
    fi
}

# Test connectivity
test_connectivity() {
    terraform refresh || echo "Terraform Refresh Failed."  # Refresh States
    echo "Running Tests..."
    while IFS=' ' read -r rg_name vm_name vm_pip other_vm_ip; do
        echo "Pinging '$other_vm_ip' from '$vm_name'"
        if ! az vm run-command invoke \
            --resource-group "$rg_name" \
            --name "$vm_name" \
            --command-id RunShellScript \
            --scripts "/bin/bash -c 'ping -c4 $other_vm_ip'" | jq -r '.value[0].message'; then
            echo "Test failed for VM: $vm_name"
            return 1
        fi

    done <<EOF
$(terraform output -raw rg1) $(terraform output -raw vm1) $(terraform output -raw vm1_public_ip) $(terraform output -raw vm2_private_ip)
$(terraform output -raw rg2) $(terraform output -raw vm2) $(terraform output -raw vm2_public_ip) $(terraform output -raw vm1_private_ip)
EOF
}

# Destroy infrastructure resources
destroy() {
    echo "Destroying Infrastructure Resources..."
    if ! terraform destroy -compact-warnings -auto-approve; then
        echo "Something went wrong with resource destruction."
    fi

    echo "Deleting NetworkWatcherRG resource group..."
    if ! az group delete -y --no-wait --name NetworkWatcherRG; then
        echo "Failed to delete NetworkWatcherRG."
    fi
}


main() {
    SLEEP_FOR=10

    pre_deployment
    deploy
    echo "Sleeping for $SLEEP_FOR seconds before testing..."
    sleep $SLEEP_FOR
    test_connectivity || { echo "Tests failed! Destroying resources..."; destroy; exit 1; }
    destroy
}

main "$@"
