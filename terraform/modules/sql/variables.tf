variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
}

variable "sql_database_name" {
  description = "Name of the SQL Database"
  type        = string
}

variable "sql_admin_username" {
  description = "SQL Server administrator username"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL Server administrator password (from Key Vault)"
  type        = string
  sensitive   = true
}

variable "vnet_id" {
  description = "Virtual Network ID for private DNS zone link"
  type        = string
}

variable "subnet_private_endpoints_id" {
  description = "Subnet ID for private endpoints"
  type        = string
}
