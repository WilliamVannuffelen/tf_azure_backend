terraform {
    required_version = ">= 1.1.5"

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">= 2.95.0"
        }
        azuread = {
            source = "hashicorp/azuread"
            version = ">= 2.17.0"
        }
        random = {
            source = "hashicorp/random"
            version = ">= 3.1.0"
        }
    }
}