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
    condition     = alltrue([for account in azurerm_storage_account.target : account.public_network_access_enabled && !account.shared_access_key_enabled && one(account.network_rules).default_action == "Deny"])
    error_message = "This is a restricted public endpoint exercise, not a Private Endpoint or shared-key exercise."
  }
  assert {
    condition     = length(azurerm_role_assignment.read_storage) == 2 && contains(azurerm_subnet.client.service_endpoints, "Microsoft.Storage") && length(azurerm_subnet.client.service_endpoint_policy_ids) == 1
    error_message = "Both accounts need the same identity permission; the endpoint policy must distinguish them."
  }

}
