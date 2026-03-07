variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "subnet_container_apps_cidr" {
  description = "CIDR block for Container Apps subnet (e.g., 10.0.1.0/24)"
  type        = string
}

variable "subnet_private_endpoints_cidr" {
  description = "CIDR block for private endpoints subnet (e.g., 10.0.2.0/24)"
  type        = string
}
