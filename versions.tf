terraform {
    required_version = ">= 1.1.2"
    backend "azurerm" {
        resource_group_name = "tfstate-01-rg"
        storage_account_name = "wvdttfstate01sa"
        container_name = "wvdttfstate01sc"
        key = "terraform.tfstate"
    }
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">= 2.92.0"
        }
    }
}