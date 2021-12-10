resource "azurerm_storage_account" "container_volume_storage_account" {
  name                     = "${var.env}stor"
  resource_group_name      = azurerm_resource_group.mvpconfrg.name
  location                 = azurerm_resource_group.mvpconfrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "volume_storage_share" {
  name                 = "aci-share"
  storage_account_name = azurerm_storage_account.container_volume_storage_account.name
  quota                = 50
}