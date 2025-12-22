# =============================================================================
# Outputs
# =============================================================================

# -----------------------------------------------------------------------------
# Resource Group
# -----------------------------------------------------------------------------

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.this.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.this.location
}

# -----------------------------------------------------------------------------
# Virtual WAN
# -----------------------------------------------------------------------------

output "vwan_id" {
  description = "ID of the Virtual WAN"
  value       = module.vwan.id
}

output "vhub_id" {
  description = "ID of the Virtual Hub"
  value       = module.vhub.id
}

# -----------------------------------------------------------------------------
# Firewall
# -----------------------------------------------------------------------------

output "firewall_private_ip" {
  description = "Private IP of the Azure Firewall in vHub"
  value       = module.vhub_firewall.private_ip_address
}

output "firewall_public_ips" {
  description = "Public IPs of the Azure Firewall in vHub"
  value       = module.vhub_firewall.public_ip_addresses
}

# -----------------------------------------------------------------------------
# VNets
# -----------------------------------------------------------------------------

output "vnet_spoke1_id" {
  description = "ID of Spoke1 VNet"
  value       = module.vnet_spoke1.id
}

output "vnet_spoke2_id" {
  description = "ID of Spoke2 VNet"
  value       = module.vnet_spoke2.id
}

output "vnet_onprem_id" {
  description = "ID of OnPrem VNet"
  value       = module.vnet_onprem.id
}

# -----------------------------------------------------------------------------
# VPN
# -----------------------------------------------------------------------------

output "onprem_vpn_gateway_public_ip" {
  description = "Public IP of the OnPrem VPN Gateway"
  value       = module.vpn_gateway_onprem.public_ip_address
}

# -----------------------------------------------------------------------------
# VMs
# -----------------------------------------------------------------------------

output "vm_spoke1_1_private_ip" {
  description = "Private IP of VM in Spoke1"
  value       = module.vm_spoke1_1.private_ip_address
}

output "vm_spoke1_2_private_ip" {
  description = "Private IP of second VM in Spoke1"
  value       = module.vm_spoke1_2.private_ip_address
}

output "vm_spoke2_1_private_ip" {
  description = "Private IP of VM in Spoke2"
  value       = module.vm_spoke2_1.private_ip_address
}

output "vm_onprem_1_private_ip" {
  description = "Private IP of VM in OnPrem"
  value       = module.vm_onprem_1.private_ip_address
}

output "vm_onprem_nva_private_ip" {
  description = "Private IP of NVA VM in OnPrem"
  value       = module.vm_onprem_nva.private_ip_address
}

# -----------------------------------------------------------------------------
# Load Balancer
# -----------------------------------------------------------------------------

output "load_balancer_frontend_ip" {
  description = "Frontend IP of the Internal Load Balancer"
  value       = module.load_balancer.frontend_ip_address
}

# -----------------------------------------------------------------------------
# Application Gateway
# -----------------------------------------------------------------------------

output "application_gateway_public_ip" {
  description = "Public IP of the Application Gateway"
  value       = var.deploy_application_gateway ? module.application_gateway[0].public_ip_address : null
}

# -----------------------------------------------------------------------------
# Bastion
# -----------------------------------------------------------------------------

output "bastion_dns_name" {
  description = "DNS name of Azure Bastion"
  value       = var.deploy_bastion ? module.bastion[0].dns_name : null
}

# -----------------------------------------------------------------------------
# DNS
# -----------------------------------------------------------------------------

output "dns_resolver_inbound_ip" {
  description = "Inbound IP of the DNS Private Resolver"
  value       = var.deploy_dns_resolver ? module.dns_resolver[0].inbound_endpoint_ip : null
}

# -----------------------------------------------------------------------------
# Storage
# -----------------------------------------------------------------------------

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage_account.name
}

output "private_endpoint_storage_ip" {
  description = "Private IP of the storage Private Endpoint"
  value       = module.private_endpoint_storage.private_ip_address
}

# -----------------------------------------------------------------------------
# Route Server
# -----------------------------------------------------------------------------

output "route_server_id" {
  description = "ID of the Azure Route Server"
  value       = var.deploy_route_server ? module.route_server[0].id : null
}

output "route_server_virtual_router_asn" {
  description = "ASN of the Azure Route Server"
  value       = var.deploy_route_server ? module.route_server[0].virtual_router_asn : null
}

output "route_server_virtual_router_ips" {
  description = "BGP peering IPs of the Azure Route Server"
  value       = var.deploy_route_server ? module.route_server[0].virtual_router_ips : null
}

output "vm_spoke1_nva_private_ip" {
  description = "Private IP of NVA VM in Spoke1"
  value       = module.vm_spoke1_nva.private_ip_address
}

# -----------------------------------------------------------------------------
# Connection Info
# -----------------------------------------------------------------------------

output "connection_info" {
  description = "Summary of connection information"
  value = {
    bastion_connect = var.deploy_bastion ? "Connect via Azure Portal -> Bastion -> ${module.bastion[0].name}" : "Bastion not deployed"
    vm_admin_user   = var.admin_username
    spoke1_vms      = [module.vm_spoke1_1.private_ip_address, module.vm_spoke1_2.private_ip_address]
    spoke1_nva      = module.vm_spoke1_nva.private_ip_address
    spoke2_vms      = [module.vm_spoke2_1.private_ip_address]
    onprem_vms      = [module.vm_onprem_1.private_ip_address, module.vm_onprem_nva.private_ip_address]
    route_server    = var.deploy_route_server ? {
      asn     = module.route_server[0].virtual_router_asn
      peer_ips = module.route_server[0].virtual_router_ips
    } : null
  }
}
