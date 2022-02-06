locals {
    az_rg           = "${var.namespace}-rg"
    az_vault_name   = "${var.namespace}-av"
    az_sa_name      = "${var.namespace}sa"
    az_sc_name      = "${var.namespace}sc"
    az_app_name     = "${var.namespace}-app"
    az_sp_name      = "${var.namespace}-sp"
}

data "azuread_client_config" "current" {}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "az_rg" {
    name        = local.az_rg
    location    = var.az_location

    tags = {
        configuration = var.namespace
    }
}

resource "azurerm_key_vault" "az_kv" {
    name                = local.az_vault_name
    location            = azurerm_resource_group.az_rg.location
    resource_group_name = azurerm_resource_group.az_rg.name
    tenant_id           = var.az_tenant
    sku_name            = "standard"

    # grant access to the CLI context user
    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id

        secret_permissions = [
            "Get",
            "Delete",
            "List",
            "Purge",
            "Set"
        ]
    }

    tags = {
        configuration = var.namespace
    }
}

resource "azurerm_storage_account" "az_sa" {
    name                        = local.az_sa_name
    resource_group_name         = azurerm_resource_group.az_rg.name
    location                    = azurerm_resource_group.az_rg.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"
    allow_blob_public_access    = true

    tags = {
        configuration = var.namespace
    }
}

resource "azurerm_storage_container" "az_sc" {
    name                    = local.az_sc_name
    storage_account_name    = azurerm_storage_account.az_sa.name
    container_access_type   = "blob"
}

resource "azuread_application" "az_app" {
    display_name                = local.az_app_name
    owners                      = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "az_sp" {
    application_id  = azuread_application.az_app.application_id
    owners          = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "az_sp_pw" {
    service_principal_id    = azuread_service_principal.az_sp.id
    end_date_relative       = "17520h"
}

resource "azurerm_role_assignment" "az_ra" {
    scope                   = azurerm_resource_group.az_rg.id
    role_definition_name    = "Contributor"
    principal_id            = azuread_service_principal.az_sp.id
}

resource "azurerm_key_vault_secret" "az_kvs_sp_id" {
    name            = "sp-id"
    value           = azuread_service_principal.az_sp.id
    key_vault_id    = azurerm_key_vault.az_kv.id
}
resource "azurerm_key_vault_secret" "az_kvs_sp_key" {
    name            = "sp-key"
    value           = azuread_service_principal_password.az_sp_pw.value
    key_vault_id    = azurerm_key_vault.az_kv.id
}