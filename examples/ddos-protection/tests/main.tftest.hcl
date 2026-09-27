mock_provider "azurerm" {}
variables {
  lab_id               = "test01"
  subscription_id      = "11111111-1111-1111-1111-111111111111"
  tenant_id            = "22222222-2222-2222-2222-222222222222"
  enable_paid_features = true
  ssh_public_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+f offline-test-public-fixture"
}
run "paid_features_require_opt_in" {
  command = plan
  variables { enable_paid_features = false }
  expect_failures = [azurerm_resource_group.lab]
}
run "isolated_configuration_contract" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.lab.ddos_protection_plan[0].enable && azurerm_public_ip.protected.ddos_protection_mode == "VirtualNetworkInherited"
    error_message = "Protected PIP must inherit the example VNet's plan."
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.attack.criteria).metric_name == "IfUnderDDoSAttack" && length(azurerm_monitor_diagnostic_setting.ddos.enabled_log) == 3 && length(azurerm_monitor_action_group.lab) == 0
    error_message = "Monitor real DDoS evidence without inventing a notification recipient."
  }

}
