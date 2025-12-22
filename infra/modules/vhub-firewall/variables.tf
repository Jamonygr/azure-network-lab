variable "name" {
  description = "Name of the Azure Firewall"
  type        = string
}

variable "policy_name" {
  description = "Name of the Firewall Policy"
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
