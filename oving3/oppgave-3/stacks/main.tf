# =============================================================================
#  stacks/  –  laget som setter komponentene sammen
# -----------------------------------------------------------------------------
#  VIKTIG: denne mappa er IKKE en stack, selv om den heter det.
#
#  Den har ingen egen state, og du kjører aldri `apply` her. Den kalles av
#  miljømappene og er dermed en helt vanlig Terraform-modul. Stacken er
#  environments/dev/ – det er der state ligger og utrullingen skjer.
#
#  Mappenavnet er innarbeidet praksis, men når kapittel 7 spør hvor mange
#  stacks du har, telles state-filer, ikke mapper.
# -----------------------------------------------------------------------------
#  Her inne skal det ikke finnes ÉN miljøspesifikk verdi. Alt som skiller dev
#  fra prod kommer inn som variabler og sendes videre. Det er dette som gjør
#  at kravet fra Oppgave 2 fortsatt holder: main.tf er identisk i alle tre
#  miljøene, fordi sammensetningen bare finnes ett sted – nemlig her.
# =============================================================================

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

  # Her ser du hva K6 er verdt i praksis. Vi slår opp subnettet PÅ NAVN:
  #
  #     module.network.subnet_ids["app"]
  #
  # Linja sier hvilket subnet maskinen havner på. Hadde outputen vært en liste,
  # måtte det stått subnet_ids[0] – en linje ingen kan lese uten å telle, og
  # som stille bytter betydning hvis noen sorterer om på subnets-variabelen.
  subnet_id = module.network.subnet_ids[var.vm_subnet_key]
}