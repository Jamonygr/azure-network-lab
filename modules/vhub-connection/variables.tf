variable "name" {
  description = "Name of the Virtual Hub Connection"
  type        = string
}

variable "virtual_hub_id" {
  description = "ID of the Virtual Hub"
  type        = string
}

variable "remote_virtual_network_id" {
  description = "ID of the remote Virtual Network to connect"
  type        = string
}

variable "internet_security_enabled" {
  description = "Enable internet security (route internet traffic through secured hub)"
  type        = bool
  default     = true
}
