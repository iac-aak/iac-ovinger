# =============================================================================
#  modules/compute/variables.tf
# =============================================================================

variable "rg_name" {
  type        = string
  description = "Navnet på ressursgruppa maskinen skal ligge i."
}

variable "location" {
  type        = string
  description = "Azure-regionen ressursene opprettes i."
}

variable "base_name" {
  type        = string
  description = "Navnegrunnlaget miljøet leverer. Modulen setter selv på 'nic-' og 'vm-'."
}

variable "subnet_id" {
  type        = string
  description = <<-TEKST
    ID-en til subnettet nettverkskortet skal ligge i.
    Kommer fra nettverksmodulens output – aldri skrevet inn for hånd.
  TEKST
}

variable "vm_size" {
  type        = string
  description = "VM-SKU, f.eks. Standard_B2as_v2. Se lista over tillatte SKU-er i oppgaven."

  validation {
    # Lista over tillatte SKU-er i tenanten vår er kjent og endelig, så vi kan
    # fange en ugyldig verdi allerede ved `plan` – i stedet for at Azure
    # avviser den midt i en `apply`.
    #
    # De to SKU-ene med "al" i navnet er utelatt med vilje: de er ARM-baserte
    # og krever et ARM-image, mens vi bruker et vanlig x86-64-image.
    condition = contains([
      "Standard_B2as_v2", "Standard_B4as_v2",
      "Standard_D2s_v5", "Standard_D4s_v5",
      "Standard_D2s_v6", "Standard_D4s_v6",
      "Standard_E2s_v5", "Standard_E4s_v5",
      "Standard_E2s_v6", "Standard_E4s_v6",
    ], var.vm_size)
    error_message = "vm_size må være en av de tillatte x86-64-SKU-ene i tenanten vår."
  }
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Lokal administratorbruker på maskinen."
}

variable "ssh_public_key" {
  type        = string
  description = <<-TEKST
    Innholdet i den offentlige SSH-nøkkelen (f.eks. ~/.ssh/id_rsa.pub).
    Den offentlige nøkkelen er ingen hemmelighet – det er den private som
    aldri skal forlate maskinen din.
  TEKST
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Felles tags fra miljøet."
}
