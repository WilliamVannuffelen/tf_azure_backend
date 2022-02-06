terraform {
    backend "azurerm" {
        resource_group_name = "wvdttfstate03-rg"
        storage_account_name = "wvdttfstate03sa"
        container_name = "wvdttfstate03sc"
        key = "terraform.tfstate"
    }
}
