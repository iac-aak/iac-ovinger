terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  tags = {
    Environment = "Demo"
    Project     = "IaC"
    Owner       = "AAK"
    CostCenter  = "IT"
  }
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-demo-aak"
  location = "West Europe"
  tags     = local.tags
}


resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-demo-aak"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "subnet2"
    address_prefixes = ["10.0.2.0/24"]
  }
}