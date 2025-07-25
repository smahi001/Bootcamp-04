output "sql_server_name" {
  value = azurerm_sql_server.sql_server.name
}
output "sql_database_id" {
  value = azurerm_sql_database.sql_db.id
}
output "sql_server_fqdn" {
  value = azurerm_sql_server.sql_server.fully_qualified_domain_name
}
