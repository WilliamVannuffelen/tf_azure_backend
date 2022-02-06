# Terraform backend configuration - Azure Blob Storage 

This repo is a simple proof of concept on how to set up and use a per-configuration Terraform backend in Azure Blob storage.

Backend creation has been refactored to use Terraform from a shell with an interactive login session to Azure via az cli.


### In short, the configuration in this repo will:

- Create a service principal with contributor role on new resource group
- Store principal's secrets in new Azure Key vault
- Set up storage account and container to store Terraform backend.
- Set up shell session for Terraform authentication to Azure
- Declare providers, backend, etc. in template configuration files.

## Usage

### Build the backend
1. Authenticate to Azure in your active shell session with 'az login --use-device-code'
2. Set the namespace variable to your desired value.
3. Use terraform init/plan/apply to deploy the configuration-specific Terraform backend.

### Use the backend
1. Run the init_azure_tf_shell.sh script from the shell_init directory in a fresh terminal session.
2. Use the preconfigured Terraform configuration files in tf_template to deploy resources using the newly created Azure resources to store the Terraform state.



