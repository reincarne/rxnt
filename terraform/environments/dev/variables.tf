variable "client_id" {
  type        = string
  description = "Service principal client ID (read from ARM_CLIENT_ID env var)"
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "Service principal client secret (read from ARM_CLIENT_SECRET env var)"
  sensitive   = true
}

variable "resource_group_name" {
  type = string
}

variable "acr_resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = string
}

variable "subnet_container_apps_cidr" {
  type = string
}

variable "subnet_private_endpoints_cidr" {
  type = string
}

variable "sql_server_name" {
  type = string
}

variable "sql_database_name" {
  type = string
}

variable "redis_name" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "api_image" {
  type = string
}

variable "site_image" {
  type = string
}

variable "site_dns_prefix" {
  type = string
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault to create"
}

variable "api_min_replicas" {
  type    = number
  default = 1
}

variable "api_max_replicas" {
  type    = number
  default = 5
}

variable "site_min_replicas" {
  type    = number
  default = 2
}

variable "site_max_replicas" {
  type    = number
  default = 10
}

variable "sql_admin_username" {
  type      = string
  sensitive = true
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "redis_access_key" {
  type      = string
  sensitive = true
}

variable "sql_admin_username_keyname" {
  type      = string
  sensitive = true
}

variable "sql_admin_password_keyname" {
  type      = string
  sensitive = true
}