resource "azurerm_public_ip" "pip" {
  name                = "${var.env}-vm-pip"
  resource_group_name = azurerm_resource_group.mvpconfrg.name
  location            = azurerm_resource_group.mvpconfrg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "main" {
  count               = local.instance_count
  name                = "${var.env}-nic${count.index}"
  resource_group_name = azurerm_resource_group.mvpconfrg.name
  location            = azurerm_resource_group.mvpconfrg.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_availability_set" "avset" {
  name                         = "${var.env}avset"
  location                     = azurerm_resource_group.mvpconfrg.location
  resource_group_name          = azurerm_resource_group.mvpconfrg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_network_security_group" "webserver" {
  name                = "tls_webserver"
  location            = azurerm_resource_group.mvpconfrg.location
  resource_group_name = azurerm_resource_group.mvpconfrg.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "tls"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    destination_address_prefix = azurerm_subnet.frontend.address_prefix
  }
}

resource "azurerm_lb" "vm_load_balancer" {
  name                = "${var.env}-lb"
  location            = azurerm_resource_group.mvpconfrg.location
  resource_group_name = azurerm_resource_group.mvpconfrg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  resource_group_name = azurerm_resource_group.mvpconfrg.name
  loadbalancer_id     = azurerm_lb.vm_load_balancer.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_rule" "lb_nat_rule" {
  resource_group_name            = azurerm_resource_group.mvpconfrg.name
  loadbalancer_id                = azurerm_lb.vm_load_balancer.id
  name                           = "HTTPSAccess"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = azurerm_lb.vm_load_balancer.frontend_ip_configuration[0].name
}

resource "azurerm_network_interface_backend_address_pool_association" "network_interface_backend_address_pool_association" {
  count                   = local.instance_count
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
  ip_configuration_name   = "primary"
  network_interface_id    = element(azurerm_network_interface.main.*.id, count.index)
}

resource "azurerm_linux_virtual_machine" "main" {
  count                           = local.instance_count
  name                            = "${var.env}-vm${count.index}"
  resource_group_name             = azurerm_resource_group.mvpconfrg.name
  location                        = azurerm_resource_group.mvpconfrg.location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = "P@ssw0rd1234!"
  availability_set_id             = azurerm_availability_set.avset.id
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main[count.index].id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
