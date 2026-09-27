variable "name" {
  description = "Name of the Application Gateway"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "Application Gateway name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for the Application Gateway"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the Application Gateway"
  type        = string
  default     = "WAF_v2"
}

variable "sku_tier" {
  description = "SKU tier for the Application Gateway"
  type        = string
  default     = "WAF_v2"
}

variable "capacity" {
  description = "Capacity (instance count) for the Application Gateway"
  type        = number
  default     = 1
}

variable "waf_enabled" {
  description = "Enable WAF configuration"
  type        = bool
  default     = true
}

variable "ctx" {
  description = "Context for location and tags."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })
}

variable "backend_ip_addresses" {
  description = "Actual IIS VM private addresses in this VNet."
  type        = list(string)
  validation {
    condition     = length(var.backend_ip_addresses) > 0
    error_message = "At least one web backend is required."
  }
}
variable "autoscale_min" {
  description = "Minimum v2 capacity; null selects fixed capacity."
  type        = number
  default     = 1
}
variable "autoscale_max" {
  description = "Maximum v2 capacity."
  type        = number
  default     = 2
}
variable "waf_mode" {
  description = "WAF policy mode."
  type        = string
  default     = "Prevention"
}
variable "certificate_secret_id" {
  description = "Versionless existing Key Vault certificate secret URI; caller provides vault network access and RBAC."
  type        = string
  default     = null
}
variable "identity_ids" {
  description = "Existing certificate-reader user-assigned identity."
  type        = set(string)
  default     = []
}
variable "host_name" {
  description = "HTTPS hostname matching the referenced certificate."
  type        = string
  default     = null
}
