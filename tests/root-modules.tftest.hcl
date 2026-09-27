# Direct module checks use mocked providers only and command=plan throughout.
mock_provider "azurerm" {
  override_during = plan
  mock_resource "azurerm_application_gateway" {
    defaults = { ssl_certificate = { id = "mock-certificate", public_cert_data = "bW9jaw==" } }
  }
  mock_data "azurerm_network_watcher" {
    defaults = { location = "westeurope", id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/NetworkWatcherRG/providers/Microsoft.Network/networkWatchers/NetworkWatcher_westeurope" }
  }
  mock_resource "azurerm_private_dns_resolver_inbound_endpoint" {
    defaults = { ip_configurations = { private_ip_address = "10.1.5.4" } }
  }
}
mock_provider "random" { override_during = plan }
variables {
  ctx                 = { project = "mocklab", location = "westeurope", tags = { Environment = "Test", Project = "mocklab" } }
  resource_group_name = "rg-mocklab"
  name                = "mocklab"
}

run "firewall_has_no_public_network_bypass" {
  command = plan
  module { source = "./modules/vhub-firewall" }
  variables {
    policy_name    = "fwpol-mocklab"
    virtual_hub_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/virtualHubs/mock"
    source_cidrs   = ["10.1.0.0/16", "10.2.0.0/16"]
    allowed_fqdns  = ["www.microsoft.com"]
  }
  assert {
    condition     = alltrue(flatten([for collection in azurerm_firewall_policy_rule_collection_group.this.network_rule_collection : [for rule in collection.rule : !contains(coalesce(rule.destination_addresses, []), "*") && !contains(rule.source_addresses, "*")]]))
    error_message = "A broad network rule would bypass the public FQDN allowlist."
  }
  assert {
    condition     = azurerm_firewall_policy.this.threat_intelligence_mode == "Deny" && one(azurerm_firewall_policy.this.dns).proxy_enabled
    error_message = "Firewall must enable DNS proxy and deny known malicious destinations."
  }
}
run "https_redirect_waf_backend_and_autoscale" {
  command = plan
  module { source = "./modules/application-gateway" }
  variables {
    subnet_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/virtualNetworks/mock/subnets/AppGwSubnet"
    backend_ip_addresses  = ["10.1.1.4", "10.1.1.5"]
    certificate_secret_id = "https://mockvault.vault.azure.net/secrets/tls"
    identity_ids          = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.ManagedIdentity/userAssignedIdentities/cert-reader"]
    host_name             = "app.example.com"
  }
  assert {
    condition     = toset(one(azurerm_application_gateway.this.backend_address_pool).ip_addresses) == toset(["10.1.1.4", "10.1.1.5"]) && one(azurerm_application_gateway.this.probe).path == "/health.html"
    error_message = "Application Gateway must target actual IIS backends and their health endpoint."
  }
  assert {
    condition     = length(azurerm_application_gateway.this.ssl_certificate) == 1 && length(azurerm_application_gateway.this.redirect_configuration) == 1 && length(azurerm_application_gateway.this.http_listener) == 2
    error_message = "HTTPS must use the referenced certificate and redirect HTTP."
  }
  assert {
    condition     = one(azurerm_application_gateway.this.autoscale_configuration).min_capacity == 1 && one(azurerm_application_gateway.this.autoscale_configuration).max_capacity == 2 && one(azurerm_web_application_firewall_policy.this[0].policy_settings).mode == "Prevention"
    error_message = "Application delivery must enable bounded autoscaling and WAF enforcement."
  }
}
run "dns_forwarding_and_links" {
  command = plan
  module { source = "./modules/dns-private-resolver" }
  variables {
    virtual_network_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/virtualNetworks/mock"
    inbound_subnet_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/virtualNetworks/mock/subnets/inbound"
    outbound_subnet_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/virtualNetworks/mock/subnets/outbound"
    forwarding_rules      = { external = { domain_name = "example.internal.", target_dns_servers = [{ ip_address = "192.168.1.4", port = 53 }] } }
    forwarding_vnet_links = { spoke2 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/virtualNetworks/spoke2" }
  }
  assert {
    condition     = azurerm_private_dns_resolver_forwarding_rule.this["external"].domain_name == "example.internal." && one(azurerm_private_dns_resolver_forwarding_rule.this["external"].target_dns_servers).ip_address == "192.168.1.4" && length(azurerm_private_dns_resolver_virtual_network_link.this) == 1
    error_message = "A resolver must have real conditional forwarding configuration and requested VNet links."
  }
}
run "dns_rejects_loop_to_own_inbound_endpoint" {
  command = plan
  module { source = "./modules/dns-private-resolver" }
  variables {
    virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/virtualNetworks/mock"
    inbound_subnet_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/virtualNetworks/mock/subnets/inbound"
    outbound_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/virtualNetworks/mock/subnets/outbound"
    forwarding_rules   = { loop = { domain_name = "loop.internal.", target_dns_servers = [{ ip_address = "10.1.5.4" }] } }
  }
  expect_failures = [azurerm_private_dns_resolver_forwarding_rule.this["loop"]]
}
run "vnet_flow_logs_and_connection_monitor" {
  command = plan
  module { source = "./modules/monitoring" }
  variables {
    network_watcher       = { name = "NetworkWatcher_westeurope", resource_group_name = "NetworkWatcherRG" }
    workspace_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.OperationalInsights/workspaces/log-mocklab"
    workspace_id          = "11111111-1111-1111-1111-111111111111"
    vnet_ids              = { spoke1 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/virtualNetworks/spoke1" }
    connection_monitor    = true
    traffic_analytics     = true
    source_vm_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Compute/virtualMachines/mock"
  }
  assert {
    condition     = endswith(azurerm_network_watcher_flow_log.vnet["spoke1"].target_resource_id, "/virtualNetworks/spoke1") && one(azurerm_network_watcher_flow_log.vnet["spoke1"].retention_policy).days == 7
    error_message = "Use VNet flow logs, with bounded retention, not retired NSG logging."
  }
  assert {
    condition     = one(azurerm_storage_account.flow[0].network_rules).default_action == "Deny" && !azurerm_storage_account.flow[0].allow_nested_items_to_be_public && one(azurerm_network_watcher_flow_log.vnet["spoke1"].traffic_analytics).enabled
    error_message = "Flow storage must reject arbitrary public clients while supporting selected analysis."
  }
  assert {
    condition     = length(azurerm_network_connection_monitor.this) == 1 && length(azurerm_virtual_machine_extension.network_watcher) == 1
    error_message = "Connection Monitor needs its Windows watcher agent."
  }
}

run "nva_launcher_preserves_script_content" {
  command = plan
  module { source = "./modules/vm-windows-nva" }
  variables {
    subnet_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mocklab/providers/Microsoft.Network/virtualNetworks/mock/subnets/NvaSubnet"
    private_ip_address = "10.1.8.10"
    admin_username     = "azureadmin"
    admin_password     = "MockOnly-Password123!"
    bgp_asn            = 65501
    route_server_ips   = ["10.1.7.4", "10.1.7.5"]
    advertised_routes  = ["10.100.0.0/16"]
  }
  assert {
    condition     = !strcontains(jsondecode(azurerm_virtual_machine_extension.rras.settings).commandToExecute, "\n") && length(split("\"", jsondecode(azurerm_virtual_machine_extension.rras.settings).commandToExecute)) == 3
    error_message = "The native command must carry one quoted argument without nested script quotes/newlines."
  }
  assert {
    condition     = strcontains(base64decode(split("'", jsondecode(azurerm_virtual_machine_extension.rras.settings).commandToExecute)[1]), "$ErrorActionPreference = 'Stop'") && strcontains(base64decode(split("'", jsondecode(azurerm_virtual_machine_extension.rras.settings).commandToExecute)[1]), "${filebase64("./modules/vm-windows-nva/configure-rras.ps1")}")
    error_message = "The transported bootstrap must enforce failure propagation and preserve the exact checked-in guest script."
  }
}
