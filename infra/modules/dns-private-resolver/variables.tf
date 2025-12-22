variable "name" {
  description = "Name of the DNS Private Resolver"
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

variable "virtual_network_id" {
  description = "ID of the Virtual Network for the resolver"
  type        = string
}

variable "inbound_subnet_id" {
  description = "ID of the subnet for the inbound endpoint"
  type        = string
}

variable "outbound_subnet_id" {
  description = "ID of the subnet for the outbound endpoint"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
