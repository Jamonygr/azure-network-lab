variable "name" {
  description = "Name of the VPN Connection"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "VPN connection name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "virtual_network_gateway_id" {
  description = "ID of the Virtual Network Gateway"
  type        = string
}

variable "local_network_gateway_id" {
  description = "ID of the Local Network Gateway"
  type        = string
}

variable "shared_key" {
  description = "Shared key for the VPN connection"
  type        = string
  sensitive   = true
}

variable "enable_bgp" {
  description = "Enable BGP for the connection"
  type        = bool
  default     = true
}

variable "ctx" {
  description = "Context for location and tags."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })
}
