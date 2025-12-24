variable "name" {
  description = "Name of the NAT Gateway"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "NAT gateway name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_associations" {
  description = "Map of subnet names to subnet IDs for NAT Gateway association"
  type        = map(string)
  default     = {}
}

variable "ctx" {
  description = "Context for location and tags."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })
}
