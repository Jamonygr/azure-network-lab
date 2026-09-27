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

variable "source_cidrs" {
  description = "Exact lab networks allowed by internal rules and public HTTPS allowlist."
  type        = list(string)
  validation {
    condition     = length(var.source_cidrs) > 0 && alltrue([for cidr in var.source_cidrs : can(cidrnetmask(cidr)) && !endswith(cidr, "/0")])
    error_message = "Use scoped IPv4 source CIDRs."
  }
}
variable "allowed_fqdns" {
  description = "Public HTTPS allowlist. Network rules do not bypass this list."
  type        = list(string)
  default     = ["www.microsoft.com", "learn.microsoft.com"]
  validation {
    condition     = length(var.allowed_fqdns) > 0 && !contains(var.allowed_fqdns, "*")
    error_message = "An explicit nonempty FQDN allowlist is required."
  }
}

variable "enable_monitoring_egress" {
  description = "Permit HTTPS to AzureMonitor service-tag addresses when monitoring agents are configured."
  type        = bool
  default     = false
}
