# Web app-stack: én definisjon for alle miljøer. Miljøet kommer inn som parameter.

terraform {
  required_version = ">= 1.16.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.7"
    }
  }
}

provider "azurerm" {
  features {}

  # Fra azurerm 5.0 registreres ingen resource providers automatisk.
  resource_providers_to_register = [
    "Microsoft.Web",
  ]
}

locals {
  base_name = lower(format("%s-%s", var.environment, var.name_prefix))

  common_tags = {
    environment = var.environment
    owner       = var.owner
    stack       = "webapps"
    managedby   = "terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-webapps-%s", local.base_name)
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_service_plan" "plan" {
  name                = format("asp-%s", local.base_name)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = var.sku
  tags                = local.common_tags
}

resource "azurerm_linux_web_app" "app" {
  name                = format("app-%s", local.base_name)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true
  tags                = local.common_tags

  site_config {
    ftps_state = "Disabled"

    application_stack {
      node_version = var.node_version
    }
  }
}
