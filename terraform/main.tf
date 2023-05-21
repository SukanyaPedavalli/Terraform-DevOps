terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm",
      version = "3.49.0"
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
    container_name       = "tf-state"
    key                  = "aks"
    resource_group_name  = "devops-common"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/virtual_network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = var.vnet_address_space


  subnets = [
    {
      name                                           = var.aks_subnet_name
      address_prefixes                               = var.aks_subnet_address_prefix
      enforce_private_link_endpoint_network_policies = true
      enforce_private_link_service_network_policies  = false
    }
  ]
}

module "aks" {
  source                                = "./modules/aks"
  name                                  = var.aks_name
  dns_prefix                            = var.aks_name
  resource_group_name                   = azurerm_resource_group.rg.name
  location                              = var.location
  admin_username                        = var.admin_username
  default_node_pool_name                = "default"
  default_node_pool_vm_size             = var.default_node_pool_vm_size
  default_node_pool_min_count           = 1
  default_node_pool_max_count           = 3
  outbound_type                         = "loadBalancer"
  vnet_subnet_id                        = module.network.subnet_ids[var.aks_subnet_name]
  default_node_pool_enable_auto_scaling = true
  ssh_public_key                        = var.ssh_public_key
}

module "standard_aks_node_pool" {
  source                = "./modules/nodepool"
  name                  = "standard"
  kubernetes_cluster_id = module.aks.id
  vm_size               = var.agent_node_pool_vm_size
  min_count             = 1
  max_count             = 3
  node_count            = 1
}
