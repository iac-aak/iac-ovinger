locals {
  company = var.company
  project = "${var.company}-${var.project}"

  common_tags = {
    Company     = local.company
    Project     = local.project
    BillingCode = var.billing_code
  }
}