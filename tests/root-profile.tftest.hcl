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

# Invoke once per actual profiles/<name>.tfvars.example; CLI values supply deploy.
run "profile_wiring" {
  command = plan
  assert {
    condition     = !var.deploy.vpn || (local.vhub_gateway_tunnel_ip == "203.0.113.20" && local.vhub_gateway_default_ip == "10.10.0.4")
    error_message = "AzureRM gateway address sets must resolve to concrete S2S tunnel/BGP addresses."
  }
  assert {
    condition     = length(module.vm_windows) == (var.deploy.spoke1_vms ? 2 : 0) + (var.deploy.spoke2_vms ? 1 : 0) + (var.deploy.onprem_vms ? 1 : 0)
    error_message = "The profile must create only its requested ordinary VMs."
  }
  assert {
    condition     = length(module.vm_nva) == (var.deploy.nvas ? 2 : 0) && length(module.log_analytics) == (var.deploy.log_analytics ? 1 : 0)
    error_message = "NVA/workspace toggles must preserve their requested counts."
  }
  assert {
    condition     = length(module.vnet_peering) == (var.deploy.spoke_peering || var.deploy.route_server ? 2 : 0)
    error_message = "Minimal/Route Server topology needs two directed spoke peerings; other profiles retain their original topology."
  }
  assert {
    condition     = length(module.vhub_connection) == (var.deploy.vwan ? (var.deploy.route_server ? 1 : 2) : 0)
    error_message = "Route Server and a vHub connection cannot share Spoke1."
  }
  assert {
    condition     = length(module.application_gateway) == (var.deploy.application_gateway ? 1 : 0) && length(module.load_balancer) == (var.deploy.load_balancer ? 1 : 0)
    error_message = "Application delivery services must follow the profile."
  }
  assert {
    condition     = length(module.dns_resolver) == (var.deploy.dns_resolver ? 1 : 0) && length(module.private_endpoint_storage) == (var.deploy.private_endpoint ? 1 : 0)
    error_message = "DNS and Private Endpoint switches must remain independent."
  }
  assert {
    condition     = alltrue(flatten([for vnet in values(output.subnet_default_outbound_access) : [for enabled in values(vnet) : !enabled]]))
    error_message = "Implicit outbound access must be disabled on every subnet."
  }
  assert {
    condition     = output.subnet_address_plan.spoke1.Workload == "10.1.1.0/24" && output.subnet_address_plan.spoke1.DnsResolverOutbound == "10.1.5.16/28" && output.subnet_address_plan.onprem.NvaSubnet == "192.168.2.0/24"
    error_message = "Default offsets must preserve existing deployed subnet addresses."
  }
  assert {
    condition     = alltrue(flatten([for nsg in values(module.nsg) : [for rule in values(nsg.rule_sources) : rule.access == "Deny" || (rule.source != "*" && rule.source != "0.0.0.0/0")]]))
    error_message = "Allow rules must scope their sources; deny rules may cover any source."
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
