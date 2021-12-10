resource "azurerm_windows_virtual_machine_scale_set" "windows_virtual_machine_scale_set" {
  name                 = "${var.env}-windows-vmss"
  resource_group_name  = azurerm_resource_group.mvpconfrg.name
  location             = azurerm_resource_group.mvpconfrg.location
  sku                  = "Standard_F2"
  instances            = 3
  admin_username       = "adminuser"
  admin_password       = "P@ssw0rd1234!"
  computer_name_prefix = var.env

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.backend.id
    }
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  # Since these can change via auto-scaling outside of Terraform,
  # let's ignore any changes to the number of instances
  lifecycle {
    ignore_changes = ["instances"]
  }
}

resource "azurerm_monitor_autoscale_setting" "monitor_autoscale_setting" {
  name                = "autoscale-config"
  resource_group_name = azurerm_resource_group.mvpconfrg.name
  location            = azurerm_resource_group.mvpconfrg.location
  target_resource_id  = azurerm_windows_virtual_machine_scale_set.windows_virtual_machine_scale_set.id

  profile {
    name = "AutoScale"

    capacity {
      default = 3
      minimum = 1
      maximum = 5
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.windows_virtual_machine_scale_set.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.windows_virtual_machine_scale_set.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}
