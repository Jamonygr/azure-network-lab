# All providers are mocked. These tests cannot create Azure resources.
mock_provider "azurerm" {
  mock_resource "azurerm_virtual_network_gateway" {
    defaults = {
      bgp_settings = [{ peering_addresses = [{ default_addresses = ["192.168.0.4"] }] }]
    }
  }
  mock_data "azurerm_network_watcher" {
    defaults = { location = "westeurope" }
  }
}
mock_provider "random" {}
variables {
  subscription_id = "00000000-0000-0000-0000-000000000000"
  ctx             = { project = "mocklab", location = "westeurope", tags = { Environment = "Test", Project = "mocklab", ManagedBy = "Terraform", Purpose = "AZ-700 Networking Lab" } }
  admin_password  = "MockOnly-Password123!"
  vpn_shared_key  = "MockOnly-SharedKey123!"
}

run "minimal_requires_no_credentials" {
  command = plan
  variables {
    deploy         = { log_analytics = false, spoke_peering = true }
    admin_password = null
    vpn_shared_key = null
  }
  assert {
    condition     = length(module.vnet) == 3 && length(module.nsg) == 3 && length(module.vnet_peering) == 2 && length(module.vm_windows) == 0 && length(module.vm_nva) == 0 && length(module.log_analytics) == 0 && length(module.vhub) == 0 && length(module.nat_gateway) == 0
    error_message = "Minimal must retain basic networks but no paid compute/gateways/workspace."
  }
}
run "custom_address_plan" {
  command = plan
  variables {
    deploy               = { log_analytics = false }
    spoke1_address_space = ["10.20.0.0/20"]
    spoke2_address_space = ["10.30.0.0/16"]
    onprem_address_space = ["172.20.0.0/16"]
  }
  assert {
    condition     = output.subnet_address_plan.spoke1.NvaSubnet == "10.20.8.0/24" && output.subnet_address_plan.spoke2.Workload == "10.30.1.0/24" && output.subnet_address_plan.onprem.GatewaySubnet == "172.20.0.0/27"
    error_message = "Custom VNet CIDRs must change every derived subnet instead of retaining original static ranges."
  }
}
run "reject_overlapping_ranges" {
  command = plan
  variables { spoke2_address_space = ["10.1.0.0/16"] }
  expect_failures = [var.validate_address_plan]
}
run "reject_noncanonical_cidr" {
  command = plan
  variables { spoke1_address_space = ["10.1.1.0/16"] }
  expect_failures = [var.spoke1_address_space]
}
run "reject_firewall_without_hub" {
  command = plan
  variables { deploy = { vhub_firewall = true } }
  expect_failures = [var.deploy]
}
run "reject_vm_without_egress" {
  command = plan
  variables { deploy = { spoke1_vms = true } }
  expect_failures = [var.deploy]
}
run "reject_vm_without_password" {
  command = plan
  variables {
    deploy         = { spoke1_vms = true, nat_gateway = true }
    admin_password = null
  }
  expect_failures = [var.admin_password]
}
run "reject_vpn_without_key" {
  command = plan
  variables {
    deploy         = { vwan = true, vpn = true }
    vpn_shared_key = null
  }
  expect_failures = [var.vpn_shared_key]
}
run "reject_tls_without_identity" {
  command = plan
  variables {
    application_gateway = { certificate_secret_id = "https://mockvault.vault.azure.net/secrets/tls", host_name = "app.example.com" }
  }
  expect_failures = [var.application_gateway]
}
run "reject_monitoring_without_watcher" {
  command = plan
  variables { deploy = { monitoring = true, log_analytics = true } }
  expect_failures = [var.monitoring]
}
run "reject_unscoped_admin_access" {
  command = plan
  variables { administration_source_cidrs = ["0.0.0.0/0"] }
  expect_failures = [var.administration_source_cidrs]
}
run "reject_wildcard_firewall" {
  command = plan
  variables { firewall_allowed_fqdns = ["*"] }
  expect_failures = [var.firewall_allowed_fqdns]
}
run "legacy_object_keeps_workspace" {
  command = plan
  variables { deploy = { private_dns_zones = true } }
  assert {
    condition     = length(module.log_analytics) == 1
    error_message = "Previously explicit deploy objects must retain their implicit workspace."
  }
}

# Azure populates optional BGP address blocks after provisioning; the schema-only
# mock cannot invent those blocks. Override gateway outputs, not the orchestrator.
override_module {
  target = module.vpn_gateway_onprem
  outputs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/virtualNetworkGateways/vpngw-mock"
    name                = "vpngw-mock"
    public_ip_address   = "203.0.113.10"
    bgp_peering_address = "192.168.0.4"
    bgp_settings        = []
  }
}
override_module {
  target = module.vhub_vpn_gateway
  outputs = {
    id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/vpnGateways/vhub-mock"
    bgp_settings = [{ instance_0_bgp_peering_address = [{ tunnel_ips = toset(["203.0.113.20"]), default_ips = toset(["10.10.0.4"]) }] }]
  }
}

run "reject_application_gateway_forced_tunnel" {
  command = plan
  variables {
    deploy = { vwan = true, vhub_firewall = true, application_gateway = true, spoke1_vms = true }
  }
  expect_failures = [var.deploy]
}
run "reject_direct_peering_around_hub" {
  command = plan
  variables { deploy = { vwan = true, spoke_peering = true } }
  expect_failures = [var.deploy]
}
