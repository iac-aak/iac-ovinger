variable "rg_name" {
  type        = string
  description = "Ressursgruppa alt legges i."
}

variable "location" {
  type        = string
  description = "Azure-region."
}

variable "base_name" {
  type        = string
  description = "Navnegrunnlag, f.eks. oppg3-dev-aak."
}

variable "address_space" {
  type        = string
  description = "Miljøets adresserom."
}

variable "subnets" {
  type        = map(number)
  description = "Subnett: navn => netnum."
}

variable "subnet_newbits" {
  type        = number
  default     = 8
  description = "Bit lagt til prefikset."
}

variable "vm_subnet_key" {
  type        = string
  default     = "app"
  description = "Nøkkel i subnets for subnettet VM-en havner i."
}

variable "vm_size" {
  type        = string
  description = "VM-SKU."
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Admin-bruker på VM-en."
}

variable "ssh_public_key" {
  type        = string
  description = "Offentlig SSH-nøkkel."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags fra miljøet."
}
