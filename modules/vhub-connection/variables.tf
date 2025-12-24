variable "name" {
  description = "Name of the Virtual Hub Connection"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "vHub connection name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "virtual_hub_id" {
  description = "ID of the Virtual Hub"
  type        = string
}

variable "remote_virtual_network_id" {
  description = "ID of the remote Virtual Network to connect"
  type        = string
}

variable "internet_security_enabled" {
  description = "Enable internet security (route internet traffic through secured hub)"
  type        = bool
  default     = true
}

variable "ctx" {
  description = "Context object (unused but standardized)."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })
}
