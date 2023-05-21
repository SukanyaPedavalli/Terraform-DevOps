terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }

  required_version = ">= 0.14.9"
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  name = "${var.name}Identity"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
    name = var.name
    location = var.location
    resource_group_name = var.resource_group_name
    kubernetes_version = var.kubernetes_version
    dns_prefix = var.dns_prefix
    private_cluster_enabled = var.private_cluster_enabled
    automatic_channel_upgrade = var.automatic_channel_upgrade
    sku_tier = var.sku_tier
    workload_identity_enabled = var.workload_identity_enabled
    azure_policy_enabled = var.azure_policy_enabled
    http_application_routing_enabled = var.http_application_routing_enabled

    default_node_pool {
      name = var.default_node_pool_name
      vm_size = var.default_node_pool_vm_size
      vnet_subnet_id = var.vnet_subnet_id
      pod_subnet_id = var.pod_subnet_id
      zones = var.default_node_pool_availability_zones
      node_labels = var.default_node_pool_node_labels
      node_taints = var.default_node_pool_node_taints
      enable_auto_scaling = var.default_node_pool_enable_auto_scaling
      enable_host_encryption = var.default_node_pool_enable_host_encryption
      enable_node_public_ip = var.default_node_pool_enable_node_public_ip
      max_pods = var.default_node_pool_max_pods
      max_count = var.default_node_pool_max_count
      min_count = var.default_node_pool_min_count
      node_count = var.default_node_pool_node_count
      os_disk_type = var.default_node_pool_os_disk_type
      tags = var.tags
    }

    linux_profile {
        admin_username = var.admin_username
        ssh_key {
            key_data = var.ssh_public_key
        }
    }

    identity {
        type = "User Assigned"
        identity_ids = tolist([azurerm_user_assigned_identity.aks_identity.id])
        }
    }
