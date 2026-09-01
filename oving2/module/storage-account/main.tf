terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.9.0"
    }
  }
}

resource "random_string" "sa_name" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "demo" {
  name                     = "${lower(var.base_name)}${random_string.sa_name.result}"
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}