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

variable "forwarding_rules" {
  description = "Conditional DNS forwarding rules for actual reachable DNS servers."
  type        = map(object({ domain_name = string, enabled = optional(bool, true), target_dns_servers = list(object({ ip_address = string, port = optional(number, 53) })) }))
  default     = {}
}
variable "forwarding_vnet_links" {
  description = "Named VNet IDs linked to the forwarding ruleset."
  type        = map(string)
  default     = {}
}
