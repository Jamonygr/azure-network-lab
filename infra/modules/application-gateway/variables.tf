variable "name" {
  description = "Name of the Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
