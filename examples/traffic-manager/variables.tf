variable "lab_id" {
  description = "Unique disposable lab identifier."
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9]{2,11}$", var.lab_id))
    error_message = "Use 3-12 lowercase letters/digits, starting with a letter."
  }
}
variable "subscription_id" {
  description = "Explicit target subscription GUID."
  type        = string
  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id))
    error_message = "Supply a subscription GUID."
  }
}
variable "tenant_id" {
  description = "Microsoft Entra tenant GUID."
  type        = string
  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.tenant_id))
    error_message = "Supply a tenant GUID."
  }
}
variable "location" {
  description = "Azure region supporting the selected services."
  type        = string
  default     = "westeurope"
}
variable "enable_paid_features" {
  description = "Acknowledge billable resources after reviewing current prices."
  type        = bool
  default     = false
}

variable "secondary_location" {
  type        = string
  default     = "northeurope"
  description = "Distinct second App Service region."
  validation {
    condition     = var.secondary_location != var.location
    error_message = "Use distinct regions."
  }
}
variable "routing_method" {
  type        = string
  default     = "Priority"
  description = "DNS routing algorithm."
  validation {
    condition     = contains(["Priority", "Weighted", "Geographic", "Performance"], var.routing_method)
    error_message = "Choose Priority, Weighted, Geographic or Performance."
  }
}
variable "endpoint_weights" {
  type        = map(number)
  default     = { primary = 80, secondary = 20 }
  description = "Weighted routing values."
  validation {
    condition     = alltrue([for key in ["primary", "secondary"] : try(var.endpoint_weights[key] >= 1 && var.endpoint_weights[key] <= 1000, false)])
    error_message = "Supply primary and secondary weights between 1 and 1000."
  }
}
variable "geographic_mappings" {
  type        = map(list(string))
  default     = { primary = ["GEO-EU"], secondary = ["WORLD"] }
  description = "Geo hierarchy codes. WORLD catches unmapped locations."
  validation {
    condition     = alltrue([for key in ["primary", "secondary"] : try(length(var.geographic_mappings[key]) > 0, false)])
    error_message = "Supply at least one geography per endpoint."
  }
}
