variable "name" {
  description = "Name of the Route Server"
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
  description = "ID of the RouteServerSubnet"
  type        = string
}

variable "branch_to_branch_traffic_enabled" {
  description = "Enable branch-to-branch traffic (transit between NVAs)"
  type        = bool
  default     = true
}

variable "bgp_connections" {
  description = "Map of BGP connections to NVAs"
  type = map(object({
    peer_asn = number
    peer_ip  = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
