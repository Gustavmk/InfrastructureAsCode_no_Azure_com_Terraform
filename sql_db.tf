
resource "azurerm_mssql_server" "mssql_server_primary" {
  name                         = "${var.env}-server-primary"
  resource_group_name          = azurerm_resource_group.mvpconfrg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "mradministrator"
  administrator_login_password = "thisIsDog11"
}

resource "azurerm_mssql_server" "mssql_server_secondary" {
  name                         = "${var.env}-server-secondary"
  resource_group_name          = azurerm_resource_group.mvpconfrg.name
  location                     = var.location_alt
  version                      = "12.0"
  administrator_login          = "mradministrator"
  administrator_login_password = "thisIsDog11"
}

resource "azurerm_mssql_database" "mssql_database_primary" {
  name         = "${var.env}-mssql-db-primary"
  server_id    = azurerm_mssql_server.mssql_server_primary.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "BasePrice"
  sku_name     = "BC_Gen5_2"
}

resource "azurerm_mssql_database" "mssql_database_secondary" {
  name                        = "${var.env}-mssql-db-secondary"
  server_id                   = azurerm_mssql_server.mssql_server_secondary.id
  create_mode                 = "Secondary"
  creation_source_database_id = azurerm_mssql_database.mssql_database_primary.id
}

resource "azurerm_sql_failover_group" "sql_failover_group" {
  name                = "${var.env}-mssql-db-failover-group"
  resource_group_name = azurerm_resource_group.mvpconfrg.name
  server_name         = azurerm_mssql_server.mssql_server_primary.name
  databases           = [azurerm_mssql_database.mssql_database_primary.id]

  partner_servers {
    id = azurerm_mssql_server.mssql_server_secondary.id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }

  depends_on = [azurerm_mssql_database.mssql_database_secondary]
}

resource "azurerm_monitor_diagnostic_setting" "monitor_diagnostic_setting" {
  name                       = "${var.env}-monitor-diagnostic-setting"
  target_resource_id         = "${azurerm_mssql_server.mssql_server_primary.id}/databases/master"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  log {
    category = "SQLSecurityAuditEvents"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }

  lifecycle {
    ignore_changes = [log, metric]
  }
}

resource "azurerm_storage_account" "storage_account_sqldb" {
  name                     = "${var.env}storagesqldb"
  resource_group_name      = azurerm_resource_group.mvpconfrg.name
  location                 = azurerm_resource_group.mvpconfrg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_mssql_database_extended_auditing_policy" "mssql_primary_database_extended_auditing_policy" {
  database_id            = "${azurerm_mssql_database.mssql_database_primary.id}/databases/master"
  storage_endpoint                        = azurerm_storage_account.storage_account_sqldb.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.storage_account_sqldb.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6
}

resource "azurerm_mssql_server_extended_auditing_policy" "mssql_primary_server_database_extended_auditing_policy" {
  server_id              = azurerm_mssql_server.mssql_server_primary.id
  storage_endpoint                        = azurerm_storage_account.storage_account_sqldb.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.storage_account_sqldb.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6
}