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
    condition     = !azurerm_linux_web_app.origin.public_network_access_enabled && azurerm_cdn_frontdoor_origin.lab.certificate_name_check_enabled
    error_message = "Origin must stay private with certificate validation."
  }
  assert {
    condition     = azurerm_cdn_frontdoor_profile.lab.sku_name == "Premium_AzureFrontDoor" && azurerm_cdn_frontdoor_firewall_policy.lab.mode == "Prevention"
    error_message = "Private Link needs Premium; WAF must enforce rules."
  }

}
run "rules_and_cache_are_attached" {
  command = plan
  assert {
    condition     = length(azurerm_cdn_frontdoor_route.lab.cdn_frontdoor_rule_set_ids) == 1 && azurerm_cdn_frontdoor_route.lab.cache[0].query_string_caching_behavior == "IgnoreQueryString"
    error_message = "Route must attach its rule set and deterministic cache policy."
  }
  assert {
    condition     = azurerm_cdn_frontdoor_rule.lab.actions[0].response_header_action[0].header_name == "X-Lab-Rule" && azurerm_cdn_frontdoor_rule.lab.actions[0].route_configuration_override_action[0].cache_duration == "00:01:00"
    error_message = "The rule must emit evidence and a bounded one-minute demo cache."
  }
}
