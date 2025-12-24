variable "name" {
  description = "Name of the resource group"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "Resource group name must be lowercase letters, numbers, and hyphens only."
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
