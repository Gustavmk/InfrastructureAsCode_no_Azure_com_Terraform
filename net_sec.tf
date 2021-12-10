
resource "azurerm_network_security_group" "network_security_group" {
  name                = "${var.env}-net-sec-group"
  location            = azurerm_resource_group.mvpconfrg.location
  resource_group_name = azurerm_resource_group.mvpconfrg.name
}

resource "azurerm_network_security_rule" "net_sec_group_rdp_rule" {
  name                        = "RDPRule"
  resource_group_name         = azurerm_resource_group.mvpconfrg.name
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 3389
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.network_security_group.name
}

resource "azurerm_network_security_rule" "net_sec_group_mssql_rule" {
  name                        = "MSSQLRule"
  resource_group_name         = azurerm_resource_group.mvpconfrg.name
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 1433
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.network_security_group.name
}