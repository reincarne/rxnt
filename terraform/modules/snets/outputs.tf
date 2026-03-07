output "subnet_container_apps_id" {
  description = "Container Apps subnet ID"
  value       = azurerm_subnet.container_apps.id
}

output "subnet_private_endpoints_id" {
  description = "Private endpoints subnet ID"
  value       = azurerm_subnet.private_endpoints.id
}

output "nsg_private_endpoints_id" {
  description = "Private endpoints NSG ID"
  value       = azurerm_network_security_group.private_endpoints.id
}
