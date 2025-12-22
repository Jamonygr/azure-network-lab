# =============================================================================
# General Settings
# =============================================================================

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus2"
}

variable "environment" {
  description = "Environment name (e.g., lab, dev, prod)"
  type        = string
  default     = "lab"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "az700"
}

# =============================================================================
# Network Address Spaces
# =============================================================================

variable "vhub_address_prefix" {
  description = "Address prefix for the Virtual Hub"
  type        = string
  default     = "10.10.0.0/23"
}

variable "spoke1_address_space" {
  description = "Address space for Spoke1 VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "spoke2_address_space" {
  description = "Address space for Spoke2 VNet"
  type        = list(string)
  default     = ["10.2.0.0/16"]
}

variable "onprem_address_space" {
  description = "Address space for OnPrem VNet"
  type        = list(string)
  default     = ["192.168.0.0/16"]
}

# =============================================================================
# VM Settings
# =============================================================================

variable "admin_username" {
  description = "Admin username for all VMs"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "Admin password for all VMs"
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "Size for all VMs"
  type        = string
  default     = "Standard_B2s"
}

# =============================================================================
# VPN Settings
# =============================================================================

variable "vpn_shared_key" {
  description = "Shared key for VPN connections"
  type        = string
  sensitive   = true
}

# =============================================================================
# Feature Toggles
# =============================================================================

variable "deploy_bastion" {
  description = "Deploy Azure Bastion"
  type        = bool
  default     = true
}

variable "deploy_application_gateway" {
  description = "Deploy Application Gateway"
  type        = bool
  default     = true
}

variable "deploy_dns_resolver" {
  description = "Deploy DNS Private Resolver"
  type        = bool
  default     = true
}

variable "deploy_nat_gateway" {
  description = "Deploy NAT Gateway"
  type        = bool
  default     = true
}

variable "deploy_route_server" {
  description = "Deploy Azure Route Server in Spoke1"
  type        = bool
  default     = true
}

# =============================================================================
# Tags
# =============================================================================

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
