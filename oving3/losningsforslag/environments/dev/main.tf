# =============================================================================
#  environments/<miljø>/main.tf  –  STACKEN
# -----------------------------------------------------------------------------
#  Dette er en root module: her ligger provideren, her ligger state, og her
#  kjører du init, plan og apply. Etter definisjonen i kapittel 7 er det denne
#  mappa som er en stack – ikke stacks/-mappa.
#
#  K1: DENNE FILA ER IDENTISK I dev, test OG prod.
#      diff environments/dev/main.tf environments/prod/main.tf  ->  tom
#
#  Alt som skiller miljøene, ligger i terraform.tfvars. Får du utslag på diff,
#  har du hardkodet noe som burde vært en variabel.
# =============================================================================
 
terraform {
  required_version = ">= 1.5.0"
 
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
 
provider "azurerm" {
  features {}
 
  # azurerm 4.x vil vite hvilken subscription den skal jobbe mot. Lar du
  # variabelen stå som null, plukkes verdien fra miljøvariabelen
  # ARM_SUBSCRIPTION_ID eller fra den aktive subscriptionen i `az account show`.
  # Har du flere subscriptions, sett den eksplisitt i terraform.tfvars.
  subscription_id = var.subscription_id
}
 
locals {
  # Miljøet leverer BESTANDDELENE til navnet – hvem, hvilket prosjekt, hvilket
  # miljø. Modulene setter dem sammen til ferdige ressursnavn.
  #
  # Skillet er verdt å holde fast på: her nede vet vi at vi er "dev". Vi vet IKKE at et subnet skal ha snet-prefiks,
  # eller at en Windows-maskin bare tåler 15 tegn i computer_name. Den
  # kunnskapen hører hjemme i modulen som eier ressurstypen.
  base_name = lower(format("%s-%s", var.environment, var.shortname))
 
  # Felles tags. Miljøet eier disse, fordi det er miljøet som avgjør hva de
  # skal si. Husk at tags IKKE arves fra ressursgruppa til ressursene inne i
  # den – hver ressurs må ha linja selv, og derfor sendes mapet nedover.
  tags = {
    environment = var.environment
    owner       = var.shortname
    managedby   = "terraform"
  }
}
 
# Ressursgruppa opprettes på rotnivå, ikke i en modul – som i Oppgave 2.
# Den er ingen infrastrukturkomponent: den kjører ingenting, lagrer ingenting
# og kobler ingenting sammen. Den er en organisatorisk beholder, og hører
# derfor hjemme hos den som kaller modulene, ikke inne i en av dem.
resource "azurerm_resource_group" "rg" {
  name     = format("rg-%s", local.base_name)
  location = var.location
  tags     = local.tags
}
 
module "stack" {
  source = "../../stacks"
 
  rg_name   = azurerm_resource_group.rg.name
  location  = var.location
  base_name = local.base_name
  tags      = local.tags
 
  address_space  = var.address_space
  subnets        = var.subnets
  vm_size        = var.vm_size
  vm_subnet_key  = var.vm_subnet_key
  admin_username = var.admin_username
  admin_password = var.admin_password
}