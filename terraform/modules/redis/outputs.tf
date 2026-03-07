output "redis_primary_connection_string" {
  description = "Redis primary connection string"
  value       = azurerm_redis_cache.redis.primary_connection_string
  sensitive   = true
}

output "redis_ssl_port" {
  description = "Redis SSL port"
  value       = azurerm_redis_cache.redis.ssl_port
}
