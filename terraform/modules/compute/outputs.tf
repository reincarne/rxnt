output "site_fqdn" {
  description = "Site container app FQDN"
  value       = azurerm_container_app.site.ingress[0].fqdn
}

output "api_fqdn" {
  description = "API container app FQDN"
  value       = azurerm_container_app.api.ingress[0].fqdn
}

output "container_app_environment_id" {
  description = "Container App Environment ID"
  value       = azurerm_container_app_environment.env.id
}
