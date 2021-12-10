resource "azurerm_network_profile" "container_network_profile" {
  name                = "${var.env}networkprofile"
  location            = azurerm_resource_group.mvpconfrg.location
  resource_group_name = azurerm_resource_group.mvpconfrg.name

  container_network_interface {
    name = "hellocnic"

    ip_configuration {
      name      = "helloipconfig"
      subnet_id = azurerm_subnet.container_subnet.id
    }
  }
}
