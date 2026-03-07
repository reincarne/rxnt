output "key_vault_name" {
  description = "Name of the created Key Vault"
  value       = module.keyvault.key_vault_name
}

output "key_vault_id" {
  description = "ID of the created Key Vault"
  value       = module.keyvault.key_vault_id
}

output "key_vault_uri" {
  description = "URI of the created Key Vault"
  value       = module.keyvault.key_vault_uri
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.resource_group.name
}

output "site_app_fqdn" {
  description = "FQDN of the public-facing Site container app"
  value       = module.compute.site_fqdn
}

output "api_app_fqdn" {
  description = "FQDN of the internal API container app"
  value       = module.compute.api_fqdn
}

output "acr_login_server" {
  description = "Login server URL for the container registry"
  value       = module.registry.acr_login_server
}
