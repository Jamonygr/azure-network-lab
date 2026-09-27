mock_provider "azurerm" {}
variables {
  lab_id               = "test01"
  subscription_id      = "11111111-1111-1111-1111-111111111111"
  tenant_id            = "22222222-2222-2222-2222-222222222222"
  enable_paid_features = true
  ssh_public_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+f offline-test-public-fixture"
  vpn_aad_audience     = "33333333-3333-3333-3333-333333333333"
  vpn_aad_tenant_url   = "https://login.microsoftonline.com/22222222-2222-2222-2222-222222222222"
  vpn_aad_issuer_url   = "https://sts.windows.net/22222222-2222-2222-2222-222222222222/"

}
run "paid_features_require_opt_in" {
  command = plan
  variables { enable_paid_features = false }
  expect_failures = [azurerm_resource_group.lab]
}
run "isolated_configuration_contract" {
  command = plan

  assert {
    condition     = azurerm_virtual_network_gateway.lab.sku == "VpnGw1AZ" && contains(azurerm_virtual_network_gateway.lab.vpn_client_configuration[0].vpn_client_protocols, "OpenVPN") && contains(azurerm_virtual_network_gateway.lab.vpn_client_configuration[0].vpn_auth_types, "AAD")
    error_message = "P2S requires AZ gateway with OpenVPN and Entra authentication."
  }
  assert {
    condition     = azurerm_subnet.gateway.name == "GatewaySubnet" && length(azurerm_subnet.gateway.address_prefixes) == 1 && azurerm_linux_virtual_machine.target.disable_password_authentication
    error_message = "Keep a dedicated gateway subnet and private passwordless test target."
  }

}
run "reject_overlap" {
  command = plan
  variables { vpn_client_address_pool = "10.88.0.0/24" }
  expect_failures = [var.vpn_client_address_pool]
}

run "reject_ipv6" {
  command = plan
  variables { vpn_client_address_pool = "fd00::/64" }
  expect_failures = [var.vpn_client_address_pool]
}

run "reject_default_route" {
  command = plan
  variables { vpn_client_address_pool = "0.0.0.0/0" }
  expect_failures = [var.vpn_client_address_pool]
}

run "reject_public_pool" {
  command = plan
  variables { vpn_client_address_pool = "8.8.8.0/24" }
  expect_failures = [var.vpn_client_address_pool]
}

run "reject_noncanonical" {
  command = plan
  variables { vpn_client_address_pool = "172.28.10.4/24" }
  expect_failures = [var.vpn_client_address_pool]
}

run "accept_other_private_ten_range" {
  command = plan
  variables { vpn_client_address_pool = "10.90.1.0/24" }
  assert {
    condition     = azurerm_virtual_network_gateway.lab.vpn_client_configuration[0].address_space == tolist(["10.90.1.0/24"])
    error_message = "Nonoverlapping private 10/8 pools remain valid."
  }
}
