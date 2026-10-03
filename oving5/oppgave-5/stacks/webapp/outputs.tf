output "app_url" {
  value       = "https://${azurerm_linux_web_app.app.default_hostname}"
  description = "URL til web app-en."
}

output "webapp_url" {
  value       = azurerm_linux_web_app.app.default_hostname
  description = "Vertsnavn til web app-en, uten protokoll. Brukes av helsesjekken i workflowen."
}
