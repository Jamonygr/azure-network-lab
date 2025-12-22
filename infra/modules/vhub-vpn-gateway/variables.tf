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

variable "virtual_hub_id" {
  description = "ID of the Virtual Hub"
  type        = string
}

variable "scale_unit" {
  description = "Scale unit for the VPN Gateway"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
