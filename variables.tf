variable "namespace" {
    description = "Namespace used for resource naming and tagging"
    type        = string
}
variable "az_subscription" {
    description = "GUID of Azure subscription."
    type        = string
}
variable "az_tenant" {
    description = "GUID of Azure tenant."
    type        = string
}
variable "az_location" {
    description = "Azure region the resources should reside in."
    type        = string
}