// =============================================================================
// State Moves (Terraform >= 1.1)
// =============================================================================

moved {
  from = azurerm_resource_group.this
  to   = module.resource_group.azurerm_resource_group.this
}

moved {
  from = azurerm_virtual_network_peering.spoke1_to_spoke2[0]
  to   = module.vnet_peering["spoke1_to_spoke2"].azurerm_virtual_network_peering.this
}

moved {
  from = azurerm_virtual_network_peering.spoke2_to_spoke1[0]
  to   = module.vnet_peering["spoke2_to_spoke1"].azurerm_virtual_network_peering.this
}

moved {
  from = module.vnet_spoke1
  to   = module.vnet["spoke1"]
}

moved {
  from = module.vnet_spoke2
  to   = module.vnet["spoke2"]
}

moved {
  from = module.vnet_onprem
  to   = module.vnet["onprem"]
}

moved {
  from = module.nsg_spoke1
  to   = module.nsg["spoke1"]
}

moved {
  from = module.nsg_spoke2
  to   = module.nsg["spoke2"]
}

moved {
  from = module.nsg_onprem
  to   = module.nsg["onprem"]
}

moved {
  from = module.vhub_connection_spoke1[0]
  to   = module.vhub_connection["spoke1"]
}

moved {
  from = module.vhub_connection_spoke2[0]
  to   = module.vhub_connection["spoke2"]
}

moved {
  from = module.private_dns_zone_internal[0]
  to   = module.private_dns_zone["internal"]
}

moved {
  from = module.private_dns_zone_blob[0]
  to   = module.private_dns_zone["blob"]
}

moved {
  from = module.vm_spoke1_1[0]
  to   = module.vm_windows["spoke1-1"]
}

moved {
  from = module.vm_spoke1_2[0]
  to   = module.vm_windows["spoke1-2"]
}

moved {
  from = module.vm_spoke2_1[0]
  to   = module.vm_windows["spoke2-1"]
}

moved {
  from = module.vm_onprem_1[0]
  to   = module.vm_windows["onprem-1"]
}

moved {
  from = module.vm_onprem_nva[0]
  to   = module.vm_nva["onprem"]
}

moved {
  from = module.vm_spoke1_nva[0]
  to   = module.vm_nva["spoke1"]
}
