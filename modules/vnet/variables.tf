variable "name" {
  description = "Name of the Virtual Network"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "VNet name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    address_prefix                    = string
    service_endpoints                 = optional(list(string), [])
    private_endpoint_network_policies = optional(string, "Enabled")
    delegation = optional(object({
      name         = string
      service_name = string
      actions      = list(string)
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      contains(["Disabled", "Enabled", "NetworkSecurityGroupEnabled", "RouteTableEnabled"], subnet.private_endpoint_network_policies)
    ])
    error_message = "private_endpoint_network_policies must be one of Disabled, Enabled, NetworkSecurityGroupEnabled, or RouteTableEnabled."
  }
}

variable "ctx" {
  description = "Context for location and tags."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })
}
