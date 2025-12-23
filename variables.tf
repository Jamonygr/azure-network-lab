# =============================================================================
#                    🎛️  DEPLOYMENT CONTROL PANEL  🎛️
# =============================================================================
# Toggle services ON (true) or OFF (false) - One place to control everything!
# =============================================================================

variable "deploy" {
  description = "Master switches to control which services to deploy"
  type = object({
    # -------------------------------------------------------------------------
    # 🌐 CORE NETWORKING
    # -------------------------------------------------------------------------
    vwan          = bool  # Virtual WAN + Virtual Hub
    vhub_firewall = bool  # Azure Firewall in Virtual Hub (Secured Hub)
    vpn           = bool  # VPN Gateways + Site-to-Site VPN
    route_server  = bool  # Azure Route Server + BGP

    # -------------------------------------------------------------------------
    # 🔒 DNS & SECURITY
    # -------------------------------------------------------------------------
    dns_resolver       = bool  # DNS Private Resolver
    private_dns_zones  = bool  # Private DNS Zones
    bastion            = bool  # Azure Bastion (secure VM access)

    # -------------------------------------------------------------------------
    # ⚖️ LOAD BALANCING
    # -------------------------------------------------------------------------
    application_gateway = bool  # Application Gateway (WAF/L7)
    load_balancer       = bool  # Internal Load Balancer (L4)
    nat_gateway         = bool  # NAT Gateway (outbound)

    # -------------------------------------------------------------------------
    # 💾 STORAGE & PRIVATE ENDPOINTS
    # -------------------------------------------------------------------------
    private_endpoint = bool  # Storage Account + Private Endpoint

    # -------------------------------------------------------------------------
    # 🖥️ VIRTUAL MACHINES
    # -------------------------------------------------------------------------
    spoke1_vms = bool  # VMs in Spoke1 VNet
    spoke2_vms = bool  # VMs in Spoke2 VNet
    onprem_vms = bool  # VMs in OnPrem VNet
    nvas       = bool  # Network Virtual Appliances (RRAS/BGP)
  })

  default = {
    # Core Networking
    vwan          = true
    vhub_firewall = true
    vpn           = true
    route_server  = true

    # DNS & Security
    dns_resolver       = true
    private_dns_zones  = true
    bastion            = false  # Disabled by default (costly)

    # Load Balancing
    application_gateway = true
    load_balancer       = true
    nat_gateway         = true

    # Storage & Private Endpoints
    private_endpoint = true

    # Virtual Machines
    spoke1_vms = true
    spoke2_vms = true
    onprem_vms = true
    nvas       = true
  }
}

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
  default     = ""
}

# =============================================================================
# Tags
# =============================================================================

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
