# Cloud Engineering - AT1 Part 3

## Introduction
This repository contains Terraform configurations for Assessment 1 Part 3 of the ICTSS00148 Cloud Engineering for Intermediate Roles Skill Set. It includes Infrastructure-as-Code (IaC) terraform files to deploy Azure Virtual Networks and configure VNet peering.

## Network Topology

<img src="media/network-topology.png" alt="Description">

---

## Requirements

- [Terraform CLI](https://developer.hashicorp.com/terraform/install)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [JQ](https://github.com/jqlang/jq)
- SSH Public Key (e.g. `~/.ssh/id_rsa.pub`)

This repository was created on Pop!_OS 22.04 LTS (Ubuntu Jammy). I have not tested running the commands on Windows, but they should work with Git Bash, Cygwin, or WSL2.

---

## Setup

### Authenticate with Azure Account
```shell
az login
```

### VM Credentials

To create a user with a password on VMs, follow these steps:

1. Copy the sample `terraform.tfvars` file to create your own:
    ```shell
    cp terraform.tfvars.sample terraform.tfvars
    ```

2. Edit the `terraform.tfvars` file to include your desired username and password. For example:
    ```hcl
    admin_username = "yourusername"
    admin_password = "yoursecretpassword"
    ```

Make sure to use a strong password to enhance security.

---

## Commands

### Test Workflow

Run the full test workflow (`validate -> deploy -> test -> destroy`).

```bash
$ chmod +x full-test.sh
$ ./full-test.sh
```

If something goes wrong and you need to clean up the resources, run:

```bash
$ terraform destroy -compact-warnings -auto-approve
$ az group delete -y --no-wait --name NetworkWatcherRG
```

### Manual Commands

```bash
# Format and Validate
$ terraform fmt -recursive && terraform validate

# Apply
$ terraform apply -compact-warnings -auto-approve

# Destroy
$ terraform destroy -compact-warnings -auto-approve && \
    az group delete -y --no-wait --name NetworkWatcherRG
```
