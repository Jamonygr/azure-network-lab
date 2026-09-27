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
    condition     = length(azurerm_linux_web_app.region) == 2 && azurerm_traffic_manager_azure_endpoint.region["primary"].priority == 1 && azurerm_traffic_manager_azure_endpoint.region["secondary"].priority == 2
    error_message = "Two owned regions must have the intended failover order."
  }
  assert {
    condition     = azurerm_traffic_manager_profile.lab.monitor_config[0].protocol == "HTTPS" && !azurerm_traffic_manager_azure_endpoint.region["primary"].always_serve_enabled
    error_message = "Routing must respect HTTPS health probes."
  }

}
run "weighted" {
  command = plan
  variables { routing_method = "Weighted" }
  assert {
    condition     = azurerm_traffic_manager_azure_endpoint.region["primary"].weight == 80 && azurerm_traffic_manager_azure_endpoint.region["secondary"].weight == 20
    error_message = "Routing-specific settings must follow the selected algorithm."
  }
}
run "geographic" {
  command = plan
  variables { routing_method = "Geographic" }
  assert {
    condition     = contains(azurerm_traffic_manager_azure_endpoint.region["secondary"].geo_mappings, "WORLD")
    error_message = "Routing-specific settings must follow the selected algorithm."
  }
}
run "performance" {
  command = plan
  variables { routing_method = "Performance" }
  assert {
    condition     = azurerm_traffic_manager_profile.lab.traffic_routing_method == "Performance"
    error_message = "Routing-specific settings must follow the selected algorithm."
  }
}
