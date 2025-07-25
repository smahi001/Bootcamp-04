resource "azurerm_mssql_server" "sql_server" {
  name                         = var.db_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0" # Or latest stable version
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  # minimum_tls_version          = "1.2" # <--- MAKE SURE THIS LINE IS COMMENTED OR DELETED
} # <--- ENSURE THIS BRACE IS PRESENT FOR SQL SERVER RESOURCE

resource "azurerm_sql_database" "sql_db" {
  name                = var.db_name
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_mssql_server.sql_server.name
  edition             = "Standard" # Or "Basic", "Premium", "GeneralPurpose", "BusinessCritical"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb         = 250
  read_scale          = false # Enable read replicas for geo-replication if using Standard/Premium
  zone_redundant      = false # Set to true for availability zone redundancy if region supports it
  # sku                 = "S0" # <--- MAKE SURE THIS LINE IS COMMENTED OR DELETED
} # <--- ENSURE THIS BRACE IS PRESENT FOR SQL DATABASE RESOURCE

# If setting up geo-replication for Azure SQL DB:
# This requires creating a secondary database and linking it.
# For a simple setup, we're just provisioning databases in each region.
# Automated geo-replication and failover groups would be an advanced step.
# Example (not fully implemented here but for concept):
/*
resource "azurerm_sql_database_vulnerability_assessment" "primary_db_va" {
  database_id            = azurerm_sql_database.sql_db.id
  storage_account_access_key = azurerm_storage_account.sql_server_storage.primary_access_key
  storage_container_path = "${azurerm_storage_account.sql_server_storage.primary_blob_endpoint}sqldb-va/"
}

resource "azurerm_sql_database_replica" "secondary_db_replica" {
  database_id              = module.primary_database.sql_database_id # Reference primary DB
  partner_database_id      = azurerm_sql_database.sql_db.id # This instance is the replica
  replication_mode         = "Geo"
  failover_grace_period_minutes = 240
}
*/
