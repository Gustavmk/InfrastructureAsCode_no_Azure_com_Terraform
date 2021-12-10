terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  
    #backend "azurerm" {
    #    resource_group_name  = "tfstate"
    #    storage_account_name = "tfstatemvpconf"
    #    container_name       = "tstate"
    #    key                  = "mvpconf.terraform.tfstate"
    #}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "mvpconfrg" {
  name     = "mvpconf-infra"
  location = var.location
}