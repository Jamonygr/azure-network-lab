// =============================================================================
// Lab Context (single environment)
// =============================================================================

variable "ctx" {
  description = "Lab context used for naming, location, and tags."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.ctx.project))
    error_message = "ctx.project must be lowercase letters, numbers, and hyphens only."
  }

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.ctx.location))
    error_message = "ctx.location must be lowercase letters and numbers only (e.g., eastus2)."
  }
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

// =============================================================================
// Deployment Control Panel
// =============================================================================

variable "deploy" {
  description = "Master switches to control which services to deploy"
  type = object({
    // Core Networking
    vwan          = bool  // Virtual WAN + Virtual Hub
    vhub_firewall = bool  // Azure Firewall in Virtual Hub (Secured Hub)
    vpn           = bool  // VPN Gateways + Site-to-Site VPN
    route_server  = bool  // Azure Route Server + BGP

    // DNS & Security
    dns_resolver      = bool  // DNS Private Resolver
    private_dns_zones = bool  // Private DNS Zones
    bastion           = bool  // Azure Bastion (secure VM access)

    // Load Balancing
    application_gateway = bool  // Application Gateway (WAF/L7)
    load_balancer       = bool  // Internal Load Balancer (L4)
    nat_gateway         = bool  // NAT Gateway (outbound)

    // Storage & Private Endpoints
    private_endpoint = bool  // Storage Account + Private Endpoint

    // Virtual Machines
    spoke1_vms = bool  // VMs in Spoke1 VNet
    spoke2_vms = bool  // VMs in Spoke2 VNet
    onprem_vms = bool  // VMs in OnPrem VNet
    nvas       = bool  // Network Virtual Appliances (RRAS/BGP)
  })

  default = {
    vwan          = true
    vhub_firewall = true
    vpn           = true
    route_server  = true

    dns_resolver      = true
    private_dns_zones = true
    bastion           = false

    application_gateway = true
    load_balancer       = true
    nat_gateway         = true

    private_endpoint = true

    spoke1_vms = true
    spoke2_vms = true
    onprem_vms = true
    nvas       = true
  }

  validation {
    condition     = !var.deploy.vhub_firewall || var.deploy.vwan
    error_message = "deploy.vhub_firewall requires deploy.vwan to be true."
  }

  validation {
    condition     = !var.deploy.vpn || var.deploy.vwan
    error_message = "deploy.vpn requires deploy.vwan to be true."
  }
}

// =============================================================================
// Network Address Spaces
// =============================================================================

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

// =============================================================================
// VM Settings
// =============================================================================

variable "admin_username" {
  description = "Admin username for all VMs"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "Admin password for all VMs"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.admin_password) >= 12
    error_message = "admin_password must be at least 12 characters."
  }
}

variable "vm_size" {
  description = "Size for all VMs"
  type        = string
  default     = "Standard_B2s"
}

// =============================================================================
// VPN Settings
// =============================================================================

variable "vpn_shared_key" {
  description = "Shared key for VPN connections"
  type        = string
  sensitive   = true
  default     = ""

  validation {
    condition     = !var.deploy.vpn || length(var.vpn_shared_key) > 0
    error_message = "vpn_shared_key must be set when deploy.vpn is true."
  }
}
