output "primary_resource_group_name" {
  value = azurerm_resource_group.primary_rg.name
}

output "secondary_resource_group_name" {
  value = azurerm_resource_group.secondary_rg.name
}

output "primary_storage_account_name" {
  value = module.primary_storage.storage_account_name
}

output "traffic_manager_fqdn" {
  value = azurerm_traffic_manager_profile.main_tm_profile.fqdn
}

output "custom_domain_cname_record" {
  value = "${azurerm_dns_cname_record.app_cname.name}.${azurerm_dns_cname_record.app_cname.zone_name}"
}

output "primary_sql_server_fqdn" {
  value = module.primary_database.sql_server_fqdn
}

output "secondary_sql_server_fqdn" {
  value = module.secondary_database.sql_server_fqdn
}
