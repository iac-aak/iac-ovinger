variable "environment" { type = string }
variable "location" { type = string }
variable "name_prefix" {
  type    = string
  default = "demo"
}

variable "vnet_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "allow_ssh_cidr" {
  type        = string
  default     = null
  description = "Sett /32 for din offentlige IP i dev; null i test/prod."
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}
variable "admin_username" {
  type    = string
  default = "azureuser"
}
variable "ssh_public_key" { type = string }
variable "allocate_public_ip" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnets" {
  type        = map(number)
  description = "Subnett som skal opprettes: navn => netnum innenfor vnet_cidr. Overstyr i dev.tfvars for å legge til/fjerne subnett."

  default = {
    web  = 0
    app  = 1
    data = 2
  }
}

variable "vm_subnet_key" {
  type        = string
  default     = "app"
  description = "Hvilken nøkkel i var.subnets VM-en skal kobles til. Overstyr i dev.tfvars ved behov."
}

variable "owner" {
  type        = string
  description = "Eier av ressursene i miljøet."
}
