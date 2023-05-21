terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  required_version = ">= 0.14.9"
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  name = "${var.name}-Identity"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_tier            = var.sku_tier
  kubernetes_version  = var.kubernetes_version
  dns_prefix          = var.dns_prefix
  default_node_pool {
    name                = var.default_node_pool_name
    vm_size             = var.default_node_pool_vm_size
    vnet_subnet_id      = var.vnet_subnet_id
    zones               = var.default_node_pool_availability_zones
    node_labels         = var.default_node_pool_labels
    node_taints         = var.default_node_pool_taints
    enable_auto_scaling = var.default_node_pool_enable_auto_scaling
    max_count           = var.default_node_pool_max_count
    min_count           = var.default_node_pool_min_count
    os_disk_type        = var.default_node_pool_os_disk_type
    tags                = var.tags
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = tolist([azurerm_user_assigned_identity.aks_identity.id])
  }

  network_profile {
    dns_service_ip = var.network_dns_service_ip
    network_plugin = var.network_plugin
    outbound_type  = var.outbound_type
    service_cidr   = var.network_service_cidr
    pod_cidr       = "100.64.0.0/16"
    load_balancer_sku = "standard"
    pod_cidrs = ["100.64.0.0/16"]
  }

  lifecycle {
    ignore_changes = [
      kubernetes_version,
      tags
    ]
  }
}


