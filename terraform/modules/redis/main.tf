resource "azurerm_redis_cache" "redis" {
  name                          = var.redis_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  capacity                      = 1
  family                        = "C"
  sku_name                      = "Standard"
  public_network_access_enabled = false
}

# Private DNS zone so Redis FQDN resolves to private IP inside VNet
resource "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  name                  = "redis-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = var.vnet_id
}

# Private endpoint for Redis
resource "azurerm_private_endpoint" "redis" {
  name                = "pe-redis-${var.redis_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_private_endpoints_id

  private_service_connection {
    name                           = "redis-pe"
    private_connection_resource_id = azurerm_redis_cache.redis.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }

  private_dns_zone_group {
    name                 = "redis-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.redis.id]
  }
}
