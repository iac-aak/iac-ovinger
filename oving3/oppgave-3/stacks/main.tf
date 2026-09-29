# Ikke en stack (ingen state) – bare modulen miljømappene kaller.
# Ingen miljøspesifikke verdier her.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

module "network" {
  source = "../modules/network"

  rg_name        = var.rg_name
  location       = var.location
  base_name      = var.base_name
  address_space  = var.address_space
  subnets        = var.subnets
  subnet_newbits = var.subnet_newbits
  tags           = var.tags
}

module "compute" {
  source = "../modules/compute"

  rg_name        = var.rg_name
  location       = var.location
  base_name      = var.base_name
  vm_size        = var.vm_size
  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
  tags           = var.tags

  # Subnett slås opp på navn, ikke posisjon.
  subnet_id = module.network.subnet_ids[var.vm_subnet_key]
}
