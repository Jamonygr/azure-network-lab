variable "name" {
  description = "Name of the VPN Gateway"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "VPN gateway name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "gateway_subnet_id" {
  description = "ID of the GatewaySubnet"
  type        = string
}

variable "sku" {
  description = "SKU of the VPN Gateway"
  type        = string
  default     = "VpnGw1"
}

variable "enable_bgp" {
  description = "Enable BGP for the gateway"
  type        = bool
  default     = true
}

variable "bgp_asn" {
  description = "BGP ASN for the gateway"
  type        = number
  default     = 65510

  validation {
    condition     = !var.enable_bgp || (var.bgp_asn >= 1 && var.bgp_asn <= 65535)
    error_message = "bgp_asn must be between 1 and 65535 when BGP is enabled."
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
