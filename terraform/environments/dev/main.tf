module "resource_group" {
  source = "../../modules/resource_group"

  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_key_vault_secret" "sql_admin_username" {
  name         = var.sql_admin_username_keyname
  value        = var.sql_admin_username
  key_vault_id = module.keyvault.key_vault_id
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = var.sql_admin_password_keyname
  value        = var.sql_admin_password
  key_vault_id = module.keyvault.key_vault_id
}

module "keyvault" {
  source = "../../modules/keyvault"

  key_vault_name      = var.key_vault_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
}

module "vnets" {
  source = "../../modules/vnets"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
}

module "snets" {
  source = "../../modules/snets"

  resource_group_name           = module.resource_group.name
  location                      = module.resource_group.location
  vnet_name                     = module.vnets.vnet_name
  subnet_container_apps_cidr    = var.subnet_container_apps_cidr
  subnet_private_endpoints_cidr = var.subnet_private_endpoints_cidr
}

module "sql" {
  source = "../../modules/sql"

  resource_group_name         = module.resource_group.name
  location                    = module.resource_group.location
  sql_server_name             = var.sql_server_name
  sql_database_name           = var.sql_database_name
  sql_admin_username          = azurerm_key_vault_secret.sql_admin_username.value
  sql_admin_password          = azurerm_key_vault_secret.sql_admin_password.value
  vnet_id                     = module.vnets.vnet_id
  subnet_private_endpoints_id = module.snets.subnet_private_endpoints_id
}

module "redis" {
  source = "../../modules/redis"

  resource_group_name         = module.resource_group.name
  location                    = module.resource_group.location
  redis_name                  = var.redis_name
  vnet_id                     = module.vnets.vnet_id
  subnet_private_endpoints_id = module.snets.subnet_private_endpoints_id
}

module "registry" {
  source = "../../modules/registry"

  resource_group_name = var.acr_resource_group_name
  location            = module.resource_group.location
  acr_name            = var.acr_name
}

resource "null_resource" "docker_push" {

  depends_on = [module.registry]

  triggers = {
    acr_login_server = module.registry.acr_login_server
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Logging into Azure Container Registry..."
      az acr login --name ${var.acr_name}

      echo "Building imageA..."
      docker build -t ${module.registry.acr_login_server}/${var.api_image} ../../../${var.api_image}

      echo "Building imageB..."
      docker build -t ${module.registry.acr_login_server}/${var.site_image} ../../../${var.site_image}

      echo "Pushing imageA..."
      docker push ${module.registry.acr_login_server}/${var.api_image}

      echo "Pushing imageB..."
      docker push ${module.registry.acr_login_server}/${var.site_image}
    EOT
  }
}

module "compute" {
  source = "../../modules/compute"

  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location
  infrastructure_subnet_id = module.snets.subnet_container_apps_id

  db_connection_string    = module.sql.sql_connection_string
  redis_connection_string = module.redis.redis_primary_connection_string
  api_image               = var.api_image
  site_image              = var.site_image
  site_dns_prefix         = var.site_dns_prefix

  api_min_replicas  = var.api_min_replicas
  api_max_replicas  = var.api_max_replicas
  site_min_replicas = var.site_min_replicas
  site_max_replicas = var.site_max_replicas
}

