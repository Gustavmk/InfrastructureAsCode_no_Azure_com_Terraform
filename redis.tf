# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_storage_account" "storage_account_redis" {
  name                     = "${var.env}redis"
  resource_group_name      = azurerm_resource_group.mvpconfrg.name
  location                 = azurerm_resource_group.mvpconfrg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_redis_cache" "redis-cache" {
  name                = "${var.env}instredismvpconf"
  location            = azurerm_resource_group.mvpconfrg.location
  resource_group_name = azurerm_resource_group.mvpconfrg.name
  capacity            = 3
  family              = "P"
  sku_name            = "Premium"
  enable_non_ssl_port = false

  redis_configuration {
    rdb_backup_enabled            = true
    rdb_backup_frequency          = 60
    rdb_backup_max_snapshot_count = 1
    rdb_storage_connection_string = azurerm_storage_account.storage_account_redis.primary_blob_connection_string
  }
}
