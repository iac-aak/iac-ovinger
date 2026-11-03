# Reglene for selve Terraform-språket. "recommended" er et utvalg som
# TFLint-utviklerne mener alle bør ha: ubrukte variabler, manglende
# required_version, utdatert syntaks og lignende.
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# Reglene som kjenner Azure. Lastes ned fra GitHub ved `tflint --init`.
plugin "azurerm" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# Våre egne regler, i tillegg til "recommended":

# Alle navn skal være snake_case: subnet_newbits, ikke subnetNewbits.
rule "terraform_naming_convention" {
  enabled = true
}

# Alle variabler skal ha en description.
rule "terraform_documented_variables" {
  enabled = true
}

# Alle outputs skal ha en description.
rule "terraform_documented_outputs" {
  enabled = true
}