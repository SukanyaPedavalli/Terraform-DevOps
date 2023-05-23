terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm",
      version = "3.49.0"
    }
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
  sku                 = "Standard"
  domain_name_label   = try(var.domain_name_label, null)
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

