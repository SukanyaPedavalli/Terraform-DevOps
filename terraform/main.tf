terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm",
        version = "3.0.0"
      }
    }
}

provider "azurerm" {
    features { 
    } 
}

terraform {
  backend "azurerm" {
    storage_account_name = "tfestoragecommon"
    container_name = "tf-state"
    key = "vmcreation"
    resource_group_name = "devops-common"
  }
}

locals {
  storage_account_prefix = "boots"
}

resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.location
}

module "network" {
  source                       = "./modules/virtual_network"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  vnet_name                    = var.vnet_name
  address_space                = var.vnet_address_space
  

  subnets = [
    {
      name : "VMSubnet"
      address_prefixes : var.vm_subnet_address_prefix
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
    },
    {
      name : "AzureBastionSubnet"
      address_prefixes : var.bastion_subnet_address_prefix
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
    }
  ]
}

module "bastion_host" {
  source                       = "./modules/bastion_host"
  name                         = var.bastion_host_name
  location                     = var.location
  resource_group_name          = azurerm_resource_group.rg.name
  subnet_id                    = module.network.subnet_ids["AzureBastionSubnet"]
}