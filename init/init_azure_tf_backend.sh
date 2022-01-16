#!/usr/bin/env bash

# run once per configuration to create backend in Azure

# declare vars
az_subscription="bfaf4006-8e26-423d-9cbc-e33947d53a1d"
az_location="West Europe"
az_rg="tfstate-01-rg"
az_vault_name="wv-tfstate-01-av"
az_sa_name="wvdttfstate01sa"
az_sc_name="wvdttfstate01sc"
az_sp_name="wv-tfstate-01-sp"


# log on to az cli
az login
az account set --subscription "$az_subscription"

# create resources
az group create --name "$az_rg" --location "$az_location"

az keyvault create --name "$az_vault_name" \
     --resource-group "$az_rg" \
     --location "$az_location"

az storage account create --name "$az_sa_name" \
    --resource-group "$az_rg" \
    --sku "Standard_LRS" \
    --encryption-services "blob"

# grab sa key needed for sc creation
az_sa_key=$(az storage account keys list --resource-group $az_rg --account-name $az_sa_name --query [0].value -o tsv)

az storage container create --name "$az_sc_name" \
    --account-name "$az_sa_name" \
    --account-key "$az_sa_key"

# create service principal and get id and password
az_sp_info=$(az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$az_subscription/resourceGroups/$az_rg" --years 99 --name "$az_sp_name" -o tsv)
az_sp_id=$(echo $az_sp_info | awk '{print $1}')
az_sp_key=$(echo $az_sp_info | awk '{print $4}')

# save secrets to vault
az keyvault secret set --vault-name $az_vault_name \
    --name "sa-key" \
    --value "$az_sa_key"

#az keyvault secret set --vault-name $az_vault_name \
#    --name "sa-name" \
#    --value "$az_sa_name"

#az keyvault secret set --vault-name $az_vault_name \
#    --name "sc-name" \
#    --value "$az_sc_name"

az keyvault secret set --vault-name "$az_vault_name" \
    --name "sp-id" \
    --value "$az_sp_id"

az keyvault secret set --vault-name "$az_vault_name" \
    --name "sp-key" \
    --value "$az_sp_key"