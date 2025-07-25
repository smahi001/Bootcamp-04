# multi-region-dr/main.tf

terraform {
  # This is the only block you should have inside terraform {} in main.tf
  backend "azurerm" {
    resource_group_name  = "tfstate-manikonda-rg-unique"
    storage_account_name = "tfstatemanikonda01"
    container_name       = "tfstate"
    key                  = "multi-region-dr.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

# Primary Region Resources
resource "azurerm_resource_group" "primary_rg" {
  name     = var.resource_group_name_primary
  location = var.primary_region
}

module "primary_network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.primary_rg.name
  location            = var.primary_region
  vnet_name           = var.virtual_network_name_primary
}

module "primary_storage" {
  source               = "./modules/storage"
  resource_group_name  = azurerm_resource_group.primary_rg.name
  location             = var.primary_region
  storage_account_name = var.storage_account_name_primary
  replication_type     = "GRS" # Geo-Redundant Storage for replication to paired region
}

module "primary_database" {
  source              = "./modules/database"
  resource_group_name = azurerm_resource_group.primary_rg.name
  location            = var.primary_region
  db_server_name      = var.db_server_name_primary
  db_name             = var.db_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

# Secondary Region Resources (Disaster Recovery)
resource "azurerm_resource_group" "secondary_rg" {
  name     = var.resource_group_name_secondary
  location = var.secondary_region
}

module "secondary_network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.secondary_rg.name
  location            = var.secondary_region
  vnet_name           = var.virtual_network_name_secondary
}

# Note: For storage, GRS in primary automatically handles replication to a paired region.
# We'll create a separate storage account in the secondary region if needed for explicit DR,
# but GRS is the simplest for basic replication.
# For this example, we'll demonstrate GRS on primary for data replication.
# For full application failover, you'd deploy similar application infrastructure
# in the secondary region and use Traffic Manager.
module "secondary_storage" {
  source               = "./modules/storage"
  resource_group_name  = azurerm_resource_group.secondary_rg.name
  location             = var.secondary_region
  storage_account_name = var.storage_account_name_secondary
  replication_type     = "LRS" # Secondary storage can be LRS as primary GRS replicates to its paired region
}

module "secondary_database" {
  source              = "./modules/database"
  resource_group_name = azurerm_resource_group.secondary_rg.name
  location            = var.secondary_region
  db_server_name      = var.db_server_name_secondary
  db_name             = var.db_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  # Configure replication if using Azure SQL DB (e.g., geo-replication)
  # This part would require specific DB configurations
}

# DNS Failover using Azure Traffic Manager
resource "azurerm_traffic_manager_profile" "main_tm_profile" {
  name                   = "tmprofile-manikondadr-unique"
  resource_group_name    = azurerm_resource_group.primary_rg.name # Can be in primary RG
  traffic_routing_method = "Priority" # Simplest for failover

  dns_config {
    relative_name = "dr-app-manikonda" # This forms dr-app-manikonda.trafficmanager.net
    ttl           = 60
  }

  monitor_config {
    protocol               = "HTTP"
    port                   = 80
    path                   = "/" # Update with your application's health check path
    interval_in_seconds    = 30
    timeout_in_seconds     = 10
    tolerated_number_of_failures = 3
  }
}

# Endpoints for Traffic Manager (example: assuming public IPs for web app)
# You'd typically deploy VMs/App Services in both regions and point Traffic Manager to their public IPs.
# For a simple walkthrough, we'll create placeholder public IPs.
resource "azurerm_public_ip" "primary_ip" {
  name                = "pip-manikondadr-primary"
  resource_group_name = azurerm_resource_group.primary_rg.name
  location            = var.primary_region
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "secondary_ip" {
  name                = "pip-manikondadr-secondary"
  resource_group_name = azurerm_resource_group.secondary_rg.name
  location            = var.secondary_region
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_traffic_manager_external_endpoint" "primary_endpoint" {
  name       = "primary-app-endpoint"
  profile_id = azurerm_traffic_manager_profile.main_tm_profile.id
  priority   = 1 # Primary will receive traffic first
  target     = azurerm_public_ip.primary_ip.ip_address
}

resource "azurerm_traffic_manager_external_endpoint" "secondary_endpoint" {
  name       = "secondary-app-endpoint"
  profile_id = azurerm_traffic_manager_profile.main_tm_profile.id
  priority   = 2 # Secondary will receive traffic if primary fails
  target     = azurerm_public_ip.secondary_ip.ip_address
}

# DNS CNAME record for your domain
resource "azurerm_dns_zone" "main_dns_zone" {
  name                = var.domain_name
  resource_group_name = azurerm_resource_group.primary_rg.name # DNS Zone can be in any RG
}

resource "azurerm_dns_cname_record" "app_cname" {
  name                = "www" # Example: www.manikonda.ca
  zone_name           = azurerm_dns_zone.main_dns_zone.name
  resource_group_name = azurerm_resource_group.primary_rg.name
  ttl                 = 300
  record              = azurerm_traffic_manager_profile.main_tm_profile.fqdn # Points to Traffic Manager FQDN
}
