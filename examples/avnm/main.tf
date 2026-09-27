locals {
  scenario = "avnm"
  tags     = { lab_id = var.lab_id, environment = "lab", managed_by = "terraform", scenario = local.scenario }
}
resource "azurerm_resource_group" "lab" {
  name     = "rg-${var.lab_id}-avnm"
  location = var.location
  tags     = local.tags
  lifecycle {
    precondition {
      condition     = var.enable_paid_features
      error_message = "Billable example disabled. Review costs and explicitly enable_paid_features."
    }
  }
}
resource "azurerm_virtual_network" "lab" {
  for_each            = { hub = "10.80.0.0/16", spoke1 = "10.81.0.0/16", spoke2 = "10.82.0.0/16" }
  name                = "vnet-${var.lab_id}-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = [each.value]
  tags                = local.tags
}
resource "azurerm_subnet" "lab" {
  for_each                        = azurerm_virtual_network.lab
  name                            = "workload"
  resource_group_name             = azurerm_resource_group.lab.name
  virtual_network_name            = each.value.name
  address_prefixes                = [cidrsubnet(one(each.value.address_space), 8, 1)]
  default_outbound_access_enabled = false
}
resource "azurerm_network_manager" "lab" {
  name                = "avnm-${var.lab_id}"
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  scope_accesses      = ["Connectivity", "SecurityAdmin", "Routing"]
  scope { subscription_ids = ["/subscriptions/${var.subscription_id}"] }
  tags = local.tags
}
resource "azurerm_network_manager_network_group" "spokes" {
  name               = "disposable-spokes"
  network_manager_id = azurerm_network_manager.lab.id
}
resource "azurerm_network_manager_static_member" "spoke" {
  for_each                  = toset(["spoke1", "spoke2"])
  name                      = each.value
  network_group_id          = azurerm_network_manager_network_group.spokes.id
  target_virtual_network_id = azurerm_virtual_network.lab[each.key].id
}
resource "azurerm_network_manager_connectivity_configuration" "lab" {
  name                            = "hub-spoke"
  network_manager_id              = azurerm_network_manager.lab.id
  connectivity_topology           = "HubAndSpoke"
  delete_existing_peering_enabled = false
  applies_to_group {
    network_group_id   = azurerm_network_manager_network_group.spokes.id
    group_connectivity = "None"
    use_hub_gateway    = false
  }
  hub {
    resource_id   = azurerm_virtual_network.lab["hub"].id
    resource_type = "Microsoft.Network/virtualNetworks"
  }
}
resource "azurerm_network_manager_security_admin_configuration" "lab" {
  name               = "deny-public-rdp"
  network_manager_id = azurerm_network_manager.lab.id
}
resource "azurerm_network_manager_admin_rule_collection" "lab" {
  name                            = "disposable-spokes"
  security_admin_configuration_id = azurerm_network_manager_security_admin_configuration.lab.id
  network_group_ids               = [azurerm_network_manager_network_group.spokes.id]
}
resource "azurerm_network_manager_admin_rule" "deny_rdp" {
  name                     = "deny-internet-rdp"
  admin_rule_collection_id = azurerm_network_manager_admin_rule_collection.lab.id
  action                   = "Deny"
  direction                = "Inbound"
  priority                 = 100
  protocol                 = "Tcp"
  source_port_ranges       = ["*"]
  destination_port_ranges  = ["3389"]
  source {
    address_prefix      = "Internet"
    address_prefix_type = "ServiceTag"
  }
  destination {
    address_prefix      = "*"
    address_prefix_type = "IPPrefix"
  }
}
resource "azurerm_network_manager_routing_configuration" "lab" {
  name               = "discard-documentation-prefix"
  network_manager_id = azurerm_network_manager.lab.id
}
resource "azurerm_network_manager_routing_rule_collection" "lab" {
  name                          = "disposable-spokes"
  routing_configuration_id      = azurerm_network_manager_routing_configuration.lab.id
  network_group_ids             = [azurerm_network_manager_network_group.spokes.id]
  bgp_route_propagation_enabled = true
}
resource "azurerm_network_manager_routing_rule" "discard" {
  name               = "discard-test-net"
  rule_collection_id = azurerm_network_manager_routing_rule_collection.lab.id
  destination {
    type    = "AddressPrefix"
    address = "192.0.2.0/24"
  }
  next_hop { type = "NoNextHop" }
}
resource "azurerm_network_manager_deployment" "connectivity" {
  network_manager_id = azurerm_network_manager.lab.id
  location           = var.location
  scope_access       = "Connectivity"
  configuration_ids  = [azurerm_network_manager_connectivity_configuration.lab.id]
  depends_on         = [azurerm_network_manager_static_member.spoke]
  triggers           = { revision = sha256(jsonencode({ configuration = azurerm_network_manager_connectivity_configuration.lab, members = azurerm_network_manager_static_member.spoke })) }
}
resource "azurerm_network_manager_deployment" "security" {
  network_manager_id = azurerm_network_manager.lab.id
  location           = var.location
  scope_access       = "SecurityAdmin"
  configuration_ids  = [azurerm_network_manager_security_admin_configuration.lab.id]
  depends_on         = [azurerm_network_manager_admin_rule.deny_rdp, azurerm_network_manager_static_member.spoke]
  triggers           = { revision = sha256(jsonencode({ configuration = azurerm_network_manager_security_admin_configuration.lab, collection = azurerm_network_manager_admin_rule_collection.lab, rule = azurerm_network_manager_admin_rule.deny_rdp, members = azurerm_network_manager_static_member.spoke })) }
}
resource "azurerm_network_manager_deployment" "routing" {
  network_manager_id = azurerm_network_manager.lab.id
  location           = var.location
  scope_access       = "Routing"
  configuration_ids  = [azurerm_network_manager_routing_configuration.lab.id]
  depends_on         = [azurerm_network_manager_routing_rule.discard, azurerm_network_manager_static_member.spoke]
  triggers           = { revision = sha256(jsonencode({ configuration = azurerm_network_manager_routing_configuration.lab, collection = azurerm_network_manager_routing_rule_collection.lab, rule = azurerm_network_manager_routing_rule.discard, members = azurerm_network_manager_static_member.spoke })) }
}
