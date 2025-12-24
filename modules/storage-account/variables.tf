variable "name_prefix" {
  description = "Prefix for the storage account name (will be suffixed with random string)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.name_prefix)) && length(var.name_prefix) <= 16
    error_message = "name_prefix must be lowercase letters/numbers only and 16 characters or fewer."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = false
}

variable "allow_public_network_access" {
  description = "Explicitly allow public network access when enabled."
  type        = bool
  default     = false
}

variable "ctx" {
  description = "Context for location and tags."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })
}
