variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "infrastructure_subnet_id" {
  description = "Subnet ID for Container App Environment"
  type        = string
}

variable "db_connection_string" {
  description = "SQL connection string"
  type        = string
  sensitive   = true
}

variable "redis_connection_string" {
  description = "Redis connection string"
  type        = string
  sensitive   = true
}

variable "api_image" {
  description = "Container image URI for API"
  type        = string
}

variable "site_image" {
  description = "Container image URI for Site"
  type        = string
}

variable "site_dns_prefix" {
  description = "DNS prefix for the site container app"
  type        = string
}

variable "api_min_replicas" {
  description = "Minimum replicas for API container app"
  type        = number
  default     = 1
}

variable "api_max_replicas" {
  description = "Maximum replicas for API container app"
  type        = number
  default     = 5
}

variable "site_min_replicas" {
  description = "Minimum replicas for Site container app"
  type        = number
  default     = 2
}

variable "site_max_replicas" {
  description = "Maximum replicas for Site container app"
  type        = number
  default     = 10
}
