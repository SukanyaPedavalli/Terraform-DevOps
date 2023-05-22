output "fqdn" {
  value       = azurerm_public_ip.public_ip.fqdn
  description = "Specifies the public fqdn for the public ip"
}

output "id" {
  value       = azurerm_public_ip.public_ip.id
  description = "Specifies the identifier of the public ip"
}

output "ip_address" {
  value       = azurerm_public_ip.public_ip.ip_address
  description = "Returns the public ip address created"
}
