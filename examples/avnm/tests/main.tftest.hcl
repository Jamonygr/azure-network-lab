mock_provider "azurerm" {}
variables {
  lab_id               = "test01"
  subscription_id      = "11111111-1111-1111-1111-111111111111"
  tenant_id            = "22222222-2222-2222-2222-222222222222"
  enable_paid_features = true

}
run "paid_features_require_opt_in" {
  command = plan
  variables { enable_paid_features = false }
  expect_failures = [azurerm_resource_group.lab]
}
run "isolated_configuration_contract" {
  command = plan

  assert {
    condition     = length(azurerm_network_manager_static_member.spoke) == 2 && !azurerm_network_manager_connectivity_configuration.lab.delete_existing_peering_enabled
    error_message = "Only disposable spokes may be selected and existing peerings must be preserved."
  }
  assert {
    condition     = azurerm_network_manager_admin_rule.deny_rdp.action == "Deny" && azurerm_network_manager_routing_rule.discard.next_hop[0].type == "NoNextHop"
    error_message = "Security and discard-route controls must remain configured."
  }

}
