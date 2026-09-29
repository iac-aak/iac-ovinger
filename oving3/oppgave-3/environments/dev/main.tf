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
  subscription_id = var.subscription_id
}

locals {
  # Miljøet leverer BESTANDDELENE til navnet – hvem, hvilket prosjekt, hvilket
  # miljø. Modulene setter dem sammen til ferdige ressursnavn (K7).
  #   project = "oppg3", environment = "dev", name_prefix = "aak"
  #   -> "oppg3-dev-aak"
  base_name = lower(format("%s-%s-%s", var.project, var.environment, var.name_prefix))

  # Felles tags. Tags arves IKKE fra ressursgruppa til ressursene inne i den –
  # hver ressurs må ha linja selv, og derfor sendes mapet nedover.
  common_tags = {
    environment = var.environment
    owner       = var.owner
    project     = var.project
    managedby   = "terraform"
  }
}

# Ressursgruppa opprettes på rotnivå, ikke i en modul – som i Oppgave 2.
# Den er en organisatorisk beholder, ingen infrastrukturkomponent, og hører
# derfor hjemme hos den som kaller modulene.
resource "azurerm_resource_group" "rg" {
  name     = format("rg-%s", local.base_name)
  location = var.location
  tags     = local.common_tags
}

module "stack" {
  source = "../../stacks"

  rg_name   = azurerm_resource_group.rg.name
  location  = var.location
  base_name = local.base_name
  tags      = local.common_tags

  address_space  = var.address_space
  subnets        = var.subnets
  vm_size        = var.vm_size
  vm_subnet_key  = var.vm_subnet_key
  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key
}
