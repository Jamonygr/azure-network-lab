variable "name" {
  description = "Name of the Private Endpoint"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "Private endpoint name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for the Private Endpoint"
  type        = string
}

variable "private_connection_resource_id" {
  description = "ID of the resource to connect to (e.g., Storage Account)"
  type        = string
}

variable "subresource_names" {
  description = "Subresource names (e.g., blob, file, queue)"
  type        = list(string)

  validation {
    condition     = length(var.subresource_names) > 0
    error_message = "subresource_names must include at least one entry."
  }
}

variable "private_dns_zone_ids" {
  description = "IDs of the Private DNS Zones to link"
  type        = list(string)
  default     = []
}

variable "ctx" {
  description = "Context for location and tags."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })
}
