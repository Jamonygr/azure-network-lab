variable "name" {
  description = "Name of the Private DNS Zone"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "virtual_network_links" {
  description = "Map of link names to VNet IDs"
  type        = map(string)
  default     = {}
}

variable "registration_enabled" {
  description = "Enable auto-registration for the zone"
  type        = bool
  default     = false
}

variable "ctx" {
  description = "Context for tags."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })
}
