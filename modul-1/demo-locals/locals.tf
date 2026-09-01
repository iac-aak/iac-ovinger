locals {

  rg_name = "${var.prefix}-${var.project}-${var.environment}-rg"
  sa_name = lower("st${var.prefix}${var.project}${var.environment}")

  # One tag set applied to every resource.
  common_tags = {
    costcenter  = var.costcenter
    environment = var.environment
    owner       = var.owner
    project     = var.project
  }
}
