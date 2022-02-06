#!/usr/bin/env bash

# run once per shell session per configuration

# declare vars
az_subscription="bfaf4006-8e26-423d-9cbc-e33947d53a1d"
az_location="West Europe"

namespace="wvdttfstate03"
az_vault_name="${namespace}-av"

# log on to az cli
az login --use-device-code # required when SSH tunneling to WSL instances or remote VMs
az account set --subscription "$az_subscription"

# query required values for env vars
az_sp_tenant_id=$(az ad sp list --display-name $az_sp_name --query [0].appOwnerTenantId)
az_sp_key=$(az keyvault secret show --subscription=$az_subscription --vault-name="$az_vault_name" --name sp-key -o tsv | awk '{print $6}')
az_sp_id=$(az keyvault secret show --subscription=$az_subscription --vault-name="$az_vault_name" --name sp-id -o tsv | awk '{print $6}')

# set env vars
export TF_VAR_client_id=$az_sp_id
export TF_VAR_client_secret=$az_sp_key
export TF_VAR_subscription_id=$az_subscription
export TF_VAR_tenant_id=$az_sp_tenant_id