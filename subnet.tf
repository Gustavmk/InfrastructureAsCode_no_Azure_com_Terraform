resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.mvpconfrg.name
  address_prefixes     = var.subnet_front
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.mvpconfrg.name
  address_prefixes     = var.subnet_back
}

resource "azurerm_subnet" "database" {
  name                 = "database"
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.mvpconfrg.name
  address_prefixes     = var.subnet_database
}

resource "azurerm_subnet" "container_subnet" {
  name                 = "container"
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.mvpconfrg.name
  address_prefixes     = var.subnet_container

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}