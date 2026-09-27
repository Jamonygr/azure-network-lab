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
    condition     = azurerm_lb.lab.sku == "Standard" && azurerm_lb_rule.web.disable_outbound_snat && !azurerm_subnet.nat.private_link_service_network_policies_enabled
    error_message = "Private Link Service requires Standard ILB and disabled NAT-subnet policies."
  }
  assert {
    condition     = azurerm_lb_probe.web.protocol == "Http" && azurerm_lb_rule.web.backend_port == 80 && azurerm_linux_virtual_machine.backend.disable_password_authentication
    error_message = "The owned web backend must be functional without password authentication."
  }

}
