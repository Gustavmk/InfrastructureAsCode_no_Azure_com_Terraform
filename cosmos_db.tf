resource "azurerm_cosmosdb_account" "mvpconfcosmos" {
  name                = "${var.env}-cosmosdb-mvpconf2021"
  location            = azurerm_resource_group.mvpconfrg.location
  resource_group_name = azurerm_resource_group.mvpconfrg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    prefix            = "${var.env}-customid"
    location          = azurerm_resource_group.mvpconfrg.location
    failover_priority = 0
  }
}
