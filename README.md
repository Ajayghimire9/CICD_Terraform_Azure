# Azure Data Foundation

Terraform for a small Azure data landing zone.

This repository defines a resource group, private blob containers and an Azure Data Factory copy pipeline. The configuration is self-contained and uses a factory managed identity to access storage.

## Run locally

```bash
cp terraform.tfvars.example terraform.tfvars
# Choose globally unique resource names, then authenticate with Azure CLI.
terraform init -backend=false
terraform fmt -check
terraform validate
terraform plan
```

## Design decisions

Duplicate variable declarations and references to missing modules have been removed.

The source and destination dataset locations use Azure Blob Storage rather than SFTP blocks. Copy activities include retry and timeout settings.

Data Factory receives Storage Blob Data Contributor through its system-assigned identity. Storage account keys are not exported.

Terraform state and local variable files are excluded from the current tree. CI checks formatting and configuration validity without applying resources.

## Technology

Terraform 1.6+, AzureRM 3.117, Azure Blob Storage, Data Factory, managed identity, GitHub Actions.

## Validation

Run `terraform fmt -check` and `terraform validate`. The Python structural check additionally parses the HCL and checks that state files are absent.

## Scope and limitations

No Azure resources are created by this repository update. Review the plan and configure an appropriate remote backend before a real deployment. Existing installations may require state migration because resource addresses changed. A copy run expects files under the source container’s incoming path; no schedule is enabled.
