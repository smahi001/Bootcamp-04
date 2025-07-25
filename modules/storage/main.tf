resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.replication_type # GRS for primary, LRS for secondary

  # Ensure unique name by adding a random suffix if not already unique
  # This is usually handled by a naming convention or a random_string resource
  # For now, rely on the variable to be unique.
}
