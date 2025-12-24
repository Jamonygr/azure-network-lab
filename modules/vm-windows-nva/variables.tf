variable "name" {
  description = "Name of the NVA Virtual Machine"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "NVA VM name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
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

variable "ctx" {
  description = "Context for location and tags."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })
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
