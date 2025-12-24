variable "name" {
  description = "Name of the Route Server"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "Route Server name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the RouteServerSubnet"
  type        = string
}

variable "branch_to_branch_traffic_enabled" {
  description = "Enable branch-to-branch traffic (transit between NVAs)"
  type        = bool
  default     = true
}

variable "bgp_connections" {
  description = "Map of BGP connections to NVAs"
  type = map(object({
    peer_asn = number
    peer_ip  = string
  }))
  default = {}
}

variable "ctx" {
  description = "Context for location and tags."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })
}
