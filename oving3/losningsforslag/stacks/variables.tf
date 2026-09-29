# =============================================================================
#  stacks/variables.tf
# -----------------------------------------------------------------------------
#  Alt dette laget trenger, kommer fra miljømappa. Ingen defaults på verdier
#  som skiller miljøene fra hverandre – de SKAL settes bevisst per miljø.
# =============================================================================
 
variable "rg_name" {
  type        = string
  description = "Ressursgruppa miljøet har opprettet, og som alle komponentene legges i."
}
 
variable "location" {
  type        = string
  description = "Azure-regionen."
}
 
variable "base_name" {
  type        = string
  description = "Navnegrunnlaget fra miljøet, f.eks. 'oppg3-dev-tim'."
}
 
variable "address_space" {
  type        = string
  description = "Adresserommet dette miljøet disponerer."
}
 
variable "subnets" {
  type        = map(number)
  description = "Subnett: navn => netnum."
}
 
variable "subnet_newbits" {
  type        = number
  default     = 8
  description = "Antall bit subnettene forlenger adresserommet med."
}
 
variable "vm_subnet_key" {
  type        = string
  default     = "app"
  description = <<-TEKST
    Hvilket subnet maskinen skal ligge i, oppgitt med NØKKELEN fra
    subnets-mapet. Dette er selve gevinsten ved for_each: valget uttrykkes
    som et navn, ikke som en posisjon.
  TEKST
 
  # Merk at det ikke går an å validere at nøkkelen finnes i var.subnets her –
  # en validation-blokk kan bare se på sin egen variabel. Skriver du en nøkkel
  # som ikke finnes, får du i stedet en tydelig feil fra oppslaget i main.tf.
}
 
variable "vm_size" {
  type        = string
  description = "VM-SKU for dette miljøet."
}
 
variable "admin_username" {
  type        = string
  default     = "tfadmin"
  description = "Lokal administratorbruker på maskinen."
}
 
variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Settes med miljøvariabelen TF_VAR_admin_password, ikke i tfvars."
}
 
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Felles tags fra miljøet."
}