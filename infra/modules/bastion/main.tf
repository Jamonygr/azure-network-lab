resource "azurerm_public_ip" "bastion" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]

  tags = var.tags
}

resource "azurerm_bastion_host" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku                    = var.sku
  copy_paste_enabled     = true
  file_copy_enabled      = var.sku == "Standard" ? true : false
  tunneling_enabled      = var.sku == "Standard" ? true : false
  ip_connect_enabled     = var.sku == "Standard" ? true : false
  shareable_link_enabled = var.sku == "Standard" ? true : false

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tags = var.tags
}
