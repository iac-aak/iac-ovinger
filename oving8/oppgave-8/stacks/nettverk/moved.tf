# =============================================================================
#  moved.tf  –  modulkallet har byttet navn, ressursene har ikke det
# -----------------------------------------------------------------------------
#  Uten denne blokken ser Terraform en adresse som forsvant og en som kom til,
#  og river og bygger alt i modulen. Med den flyttes oppføringene i state.
#
#  FJERNES når dev, test OG prod har fått endringen (side 6, steg 4).
# =============================================================================

moved {
  from = module.network
  to   = module.nettverk
}