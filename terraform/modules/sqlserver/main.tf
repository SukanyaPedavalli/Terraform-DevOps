resource "azurerm_mssql_server" "server" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  minimum_tls_version           = "1.2"
  public_network_access_enabled = var.enable_public_network_access

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_mssql_database" "database" {
  for_each  = { for db in var.databases : db => db }
  name      = each.key
  server_id = azurerm_mssql_server.server.id
}

resource "azurerm_mssql_firewall_rule" "firewall_rules" {
  for_each = { for firewall in var.firewall_rules : firewall.name => firewall }

  name             = each.key
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

module "privateendpoint" {
  source                         = "../private_endpoint"
  name                           = "${var.name}-Endpoint"
  location                       = var.location
  private_connection_resource_id = azurerm_mssql_server.server.id
  subresource_name               = "sqlServer"
  resource_group_name            = var.resource_group_name
  subnet_id                      = var.private_endpoint_subnet_id
  private_dns_zone_group_name    = "SqlServerPrivateDnsZoneGroup"
  private_dns_zone_group_ids     = [var.private_dns_zone_id]
  tags                           = var.tags
}
