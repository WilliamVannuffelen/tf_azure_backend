data "azurerm_client_config" "client" {}

resource "azurerm_resource_group" "rg" {
    name        = var.az_rg_name
    location    = var.az_location
}

resource "azurerm_key_vault" "vault" {
    name = var.az_vault_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    enabled_for_disk_encryption = true
    tenant_id = data.azurerm_client_config.client.tenant_id
    soft_delete_retention_days = 7
    purge_protection_enabled = false
    sku_name = "standard"
}

resource "azurerm_storage_account" "sa" {
    name                        = var.az_sa_name
    resource_group_name         = azurerm_resource_group.rg.name
    location                    = azurerm_resource_group.rg.location
    account_tier                = "Standard"
    account_replication_type    = "LRS" 
}

resource "azurerm_storage_container" "sc" {
    name                    = var.az_sc_name
    storage_account_name    = azurerm_storage_account.sa.name
    container_access_type   = "private"
}

