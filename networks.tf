
resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.env}-network"
  resource_group_name = azurerm_resource_group.mvpconfrg.name
  location            = azurerm_resource_group.mvpconfrg.location
  address_space       = var.network
}