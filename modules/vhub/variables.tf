variable "name" {
  description = "Name of the Virtual Hub"
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

variable "address_prefix" {
  description = "Address prefix for the Virtual Hub (e.g., 10.10.0.0/23)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
