output "sql_connection_string" {
  description = "SQL connection string for the database"
  value       = "Server=${azurerm_mssql_server.sql.fully_qualified_domain_name};Database=${azurerm_mssql_database.sql_db.name};User ID=${var.sql_admin_username};Password=${var.sql_admin_password};"
  sensitive   = true
}
