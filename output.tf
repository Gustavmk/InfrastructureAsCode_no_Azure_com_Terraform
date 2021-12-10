output "container_ip_address" {
  value = azurerm_container_group.container_group[*].ip_address
}

#the dns fqdn of the container group if dns_name_label is set
output "fqdn_container" {
  value = azurerm_container_group.container_group[*].fqdn
}

# COSMOSDB Infos
output "cosmos-db-id" {
  value = azurerm_cosmosdb_account.mvpconfcosmos.id
}

output "cosmos-db-endpoint" {
  value = azurerm_cosmosdb_account.mvpconfcosmos.endpoint
}

output "cosmos-db-endpoints_read" {
  value = azurerm_cosmosdb_account.mvpconfcosmos.read_endpoints
}

output "cosmos-db-endpoints_write" {
  value = azurerm_cosmosdb_account.mvpconfcosmos.write_endpoints
}

output "cosmos-db-primary_key" {
  value = azurerm_cosmosdb_account.mvpconfcosmos.primary_key
  sensitive = true
}

output "cosmos-db-secondary_key" {
  value = azurerm_cosmosdb_account.mvpconfcosmos.secondary_key
  sensitive = true
}