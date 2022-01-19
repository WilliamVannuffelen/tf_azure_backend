terraform {
    required_version = ">= 1.1.2"
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">= 2.92.0"
        }
    }
}