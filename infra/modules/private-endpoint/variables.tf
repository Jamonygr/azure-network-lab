variable "name" {
  description = "Name of the Private Endpoint"
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
  description = "ID of the subnet for the Private Endpoint"
  type        = string
}

variable "private_connection_resource_id" {
  description = "ID of the resource to connect to (e.g., Storage Account)"
  type        = string
}

variable "subresource_names" {
  description = "Subresource names (e.g., blob, file, queue)"
  type        = list(string)
}

variable "private_dns_zone_ids" {
  description = "IDs of the Private DNS Zones to link"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
