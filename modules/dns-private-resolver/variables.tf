variable "name" {
  description = "Name of the DNS Private Resolver"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "DNS resolver name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "virtual_network_id" {
  description = "ID of the Virtual Network for the resolver"
  type        = string
}

variable "inbound_subnet_id" {
  description = "ID of the subnet for the inbound endpoint"
  type        = string
}

variable "outbound_subnet_id" {
  description = "ID of the subnet for the outbound endpoint"
  type        = string
}

variable "ctx" {
  description = "Context for location and tags."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })
}
