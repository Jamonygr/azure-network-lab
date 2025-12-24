variable "name" {
  description = "Name of the Virtual Hub"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "Virtual Hub name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "virtual_wan_id" {
  description = "ID of the Virtual WAN"
  type        = string
}

variable "address_prefix" {
  description = "Address prefix for the Virtual Hub (e.g., 10.10.0.0/23)"
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
