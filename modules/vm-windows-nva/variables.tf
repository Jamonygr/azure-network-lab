variable "name" {
  description = "Name of the NVA Virtual Machine"
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
  description = "ID of the subnet for the VM"
  type        = string
}

variable "private_ip_address" {
  description = "Static private IP address for the NVA"
  type        = string
}

variable "size" {
  description = "Size of the VM"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "bgp_asn" {
  description = "BGP ASN for this NVA"
  type        = number
  default     = null
}

variable "route_server_ips" {
  description = "List of Route Server BGP peer IPs to establish peering with"
  type        = list(string)
  default     = []
}

variable "advertised_routes" {
  description = "List of routes to advertise via BGP (CIDR format)"
  type        = list(string)
  default     = []
}
