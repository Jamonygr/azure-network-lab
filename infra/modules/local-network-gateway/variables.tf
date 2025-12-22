variable "name" {
  description = "Name of the Local Network Gateway"
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

variable "gateway_address" {
  description = "IP address of the remote gateway (vHub VPN GW public IP)"
  type        = string
}

variable "address_space" {
  description = "Address space of the remote network (Azure vHub + spokes)"
  type        = list(string)
}

variable "bgp_enabled" {
  description = "Enable BGP for the Local Network Gateway"
  type        = bool
  default     = true
}

variable "bgp_asn" {
  description = "BGP ASN of the remote gateway"
  type        = number
  default     = 65515
}

variable "bgp_peering_address" {
  description = "BGP peering address of the remote gateway"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
