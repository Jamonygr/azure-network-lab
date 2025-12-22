variable "name" {
  description = "Name of the VPN Gateway"
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
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
