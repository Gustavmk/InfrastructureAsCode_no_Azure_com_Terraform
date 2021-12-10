resource "azurerm_container_group" "container_group" {
  name                = "${var.env}-container-instance"
  location            = azurerm_resource_group.mvpconfrg.location
  resource_group_name = azurerm_resource_group.mvpconfrg.name
  ip_address_type     = "Private"
  network_profile_id  = azurerm_network_profile.container_network_profile.id
  os_type             = "Linux"
  restart_policy      = "Never"

  image_registry_credential {
    server   = "hub.docker.com"
    username = var.docker_hub_user
    password = var.docker_hub_passwd
  }

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  container {
    name   = "sidecar"
    image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }

  container {
    name   = "webserver"
    image  = "seanmckenna/aci-hellofiles"
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

    volume {
      name       = "logs"
      mount_path = "/aci/logs"
      read_only  = false
      share_name = azurerm_storage_share.volume_storage_share.name

      storage_account_name = azurerm_storage_account.container_volume_storage_account.name
      storage_account_key  = azurerm_storage_account.container_volume_storage_account.primary_access_key
    }
  } 

  tags = {
    environment = var.env
  }
}
