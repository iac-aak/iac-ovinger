# =============================================================================
#  environments/<miljø>/variables.tf
# -----------------------------------------------------------------------------
#  Også denne fila er identisk i alle tre miljøene. Den DEKLARERER hva som kan
#  settes; terraform.tfvars SETTER verdiene for nettopp dette miljøet.
# =============================================================================

variable "name_prefix" {
  type        = string
  description = <<-TEKST
    Personlig kortnavn (aak). Alle studentene deler samme tenant, og uten
    dette kolliderer utrullingen med en medstudents.
  TEKST
}

variable "owner" {
  type        = string
  description = "Eier av ressursene i miljøet (e-post). Brukes i tags."
}

variable "project" {
  type        = string
  default     = "oppg3"
  description = "Prosjektnavnet som inngår i alle ressursnavn."
}

variable "environment" {
  type        = string
  description = "Miljønavnet: dev, test eller prod."

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment må være dev, test eller prod."
  }
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Azure-regionen ressursene opprettes i."

  validation {
    condition = contains([
      "northeurope", "uksouth", "westeurope", "norwayeast", "norwaywest",
    ], var.location)
    error_message = "Bare disse regionene er tillatt i tenanten vår."
  }
}

variable "address_space" {
  type        = string
  description = <<-TEKST
    Adresserommet DETTE miljøet disponerer, f.eks. 10.162.0.0/16.
    Ingen default: adresseplanen er en global beslutning, og en default her
    ville betydd at alle miljøer arvet samme adresse.
  TEKST
}

variable "subnets" {
  type        = map(number)
  description = "Subnett i dette miljøet: navn => netnum."
}

variable "vm_subnet_key" {
  type        = string
  default     = "app"
  description = "Nøkkelen til subnettet maskinen skal ligge i."
}

variable "vm_size" {
  type        = string
  description = "VM-SKU. Skal være mindre i dev enn i prod."
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Lokal administratorbruker på maskinen."
}

variable "ssh_public_key" {
  type        = string
  description = "Offentlig SSH-nøkkel som legges inn på maskinen."
}

variable "subscription_id" {
  type        = string
  default     = null
  description = <<-TEKST
    Subscription-ID. Står den som null, brukes ARM_SUBSCRIPTION_ID eller den
    aktive subscriptionen fra Azure CLI.
  TEKST
}
