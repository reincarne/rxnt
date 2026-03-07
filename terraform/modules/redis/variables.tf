variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "redis_name" {
  description = "Name of the Redis cache instance"
  type        = string
}

variable "vnet_id" {
  description = "Virtual Network ID for private DNS zone link"
  type        = string
}

variable "subnet_private_endpoints_id" {
  description = "Subnet ID for private endpoints"
  type        = string
}
