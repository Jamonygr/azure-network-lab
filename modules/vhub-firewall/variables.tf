variable "name" {
  description = "Name of the Azure Firewall"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "Firewall name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "policy_name" {
  description = "Name of the Firewall Policy"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.policy_name))
    error_message = "Firewall policy name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "virtual_hub_id" {
  description = "ID of the Virtual Hub"
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
