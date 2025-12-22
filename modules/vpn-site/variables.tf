variable "name" {
  description = "Name of the VPN Site"
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

variable "virtual_wan_id" {
  description = "ID of the Virtual WAN"
  type        = string
}

variable "vpn_gateway_id" {
  description = "ID of the vHub VPN Gateway"
  type        = string
}

variable "address_cidrs" {
  description = "Address CIDRs for the VPN Site (on-prem address space)"
  type        = list(string)
}

variable "vpn_device_ip" {
  description = "Public IP of the on-prem VPN device"
  type        = string
}

variable "shared_key" {
  description = "Shared key for the VPN connection"
  type        = string
  sensitive   = true
}

variable "bgp_enabled" {
  description = "Enable BGP for the VPN connection"
  type        = bool
  default     = true
}

variable "bgp_asn" {
  description = "BGP ASN for the on-prem device"
  type        = number
  default     = 65510
}

variable "bgp_peering_address" {
  description = "BGP peering address for the on-prem device"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
