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

module "ResourceGroup" {
  source    = "./resource-group"
  base_name = var.base_name
  location  = var.location
}

module "StorageAccount" {
  source    = "./storage-account"
  base_name = var.base_name
  rgname    = module.ResourceGroup.rg_name_output
  location  = module.ResourceGroup.location

}