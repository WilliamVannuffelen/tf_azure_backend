provider "azurerm" {
    features {}
    subscription_id = var.az_subscription
}
provider "azuread" {
    tenant_id = var.az_tenant
}
