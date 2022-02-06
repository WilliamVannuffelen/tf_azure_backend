resource "azurerm_resource_group" "example" {
    name        = var.namespace
    location    = var.location
}