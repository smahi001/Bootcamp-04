variable "subscription_id" {
  description = "Your Azure Subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Your Azure Tenant ID"
  type        = string
}

variable "client_id" {
  description = "Service Principal Client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Service Principal Client Secret"
  type        = string
  sensitive   = true
}

variable "primary_region" {
  description = "Azure primary region for deployment"
  type        = string
  default     = "centralindia"
}

variable "secondary_region" {
  description = "Azure secondary region for disaster recovery"
  type        = string
  default     = "southindia"
}

variable "resource_group_name_primary" {
  description = "Name for the primary resource group"
  type        = string
  default     = "rg-manikondadr-primary-unique"
}

variable "resource_group_name_secondary" {
  description = "Name for the secondary resource group"
  type        = string
  default     = "rg-manikondadr-secondary-unique"
}

variable "storage_account_name_primary" {
  description = "Name for the primary storage account"
  type        = string
  default     = "stmanikondadrprimary01" # Must be globally unique and lowercase
}

variable "storage_account_name_secondary" {
  description = "Name for the secondary storage account"
  type        = string
  default     = "stmanikondadrsecondary02" # Must be globally unique and lowercase
}

variable "virtual_network_name_primary" {
  description = "Name for the primary virtual network"
  type        = string
  default     = "vnet-manikondadr-primary"
}

variable "virtual_network_name_secondary" {
  description = "Name for the secondary virtual network"
  type        = string
  default     = "vnet-manikondadr-secondary"
}

variable "db_server_name_primary" {
  description = "Name for the primary database server"
  type        = string
  default     = "dbserver-manikondadr-primary" # Must be globally unique
}

variable "db_server_name_secondary" {
  description = "Name for the secondary database server"
  type        = string
  default     = "dbserver-manikondadr-secondary" # Must be globally unique
}

variable "db_name" {
  description = "Name for the database"
  type        = string
  default     = "manikondadbreplica"
}

variable "admin_username" {
  description = "Admin username for the database server"
  type        = string
  default     = "manikondadmin"
}

variable "admin_password" {
  description = "Admin password for the database server"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Your custom domain name for DNS failover"
  type        = string
  default     = "manikonda.ca"
}
