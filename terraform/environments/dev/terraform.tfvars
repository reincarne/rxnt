resource_group_name = "rg-dev"
location            = "eastus"

vnet_name                     = "vnet-dev"
vnet_address_space            = "10.0.0.0/16"
subnet_container_apps_cidr    = "10.0.1.0/24"
subnet_private_endpoints_cidr = "10.0.2.0/24"

sql_server_name   = "sqlserverdev"
sql_database_name = "devdb"

redis_name = "redisdev"
acr_name   = "acrdemo"
acr_resource_group_name = "acr_rg"

# image URIs should point the registry after building
api_image       = "rxnt-api:latest"
site_image      = "rxnt-site:latest"
site_dns_prefix = "devsite"

# Key Vault details for secrets
key_vault_name = "kv-dev"
# The Key Vault will be created in the same resource group and location
sql_admin_username_keyname = "sql_admin_user"
sql_admin_password_keyname = "sql_admin_pass"
sql_admin_username = "sa"
sql_admin_password = "Password123!"

# auto‑scaling parameters
api_min_replicas  = 1
api_max_replicas  = 5
site_min_replicas = 2
site_max_replicas = 10
