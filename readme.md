# Terraform backend configuration - Azure Blob Storage 

This repo is a simple proof of concept on how to set up a per-configuration Terraform backend in Azure Blob storage.

Creation has been done, for now, using bash and azure cli. Will be refactored to use Terraform in an interactive az login session at a later date.

- Create service principal with contributor role on new resource group
- Store principal's secrets in Azure Key vault
- Set up shell session for Terraform authentication to Azure
- Declare providers, backend, etc in premade configuration files.

## Usage

1. Run /init/init_azure_tf_backend.sh once per configuration to deploy the resources on Azure.
2. Run /init/init_azure_tf_shell.sh once per shell session to retrieve and set environment variables TF will use for Azure authentication


