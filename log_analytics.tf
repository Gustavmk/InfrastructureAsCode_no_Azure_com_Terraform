resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${var.env}-log-analytics-workspace"
  location            = azurerm_resource_group.mvpconfrg.location
  resource_group_name = azurerm_resource_group.mvpconfrg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

#resource "azurerm_log_analytics_solution" "container_log_analytics_solution" {
#  solution_name         = "ContainerInsights"
#  location              = azurerm_resource_group.mvpconfrg.location
#  resource_group_name   = azurerm_resource_group.mvpconfrg.name
#  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
#  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace.name
#
#  plan {
#    publisher = "Microsoft"
#    product   = "OMSGallery/Containers"
#  }
#}

resource "azurerm_log_analytics_solution" "security_log_analytics_solution" {
  solution_name         = "Security"
  location              = azurerm_resource_group.mvpconfrg.location
  resource_group_name   = azurerm_resource_group.mvpconfrg.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics_workspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Security"
  }
}