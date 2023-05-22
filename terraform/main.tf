terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm",
      version = "3.49.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
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
    key                  = "aks-sqlserver"
    resource_group_name  = "devops-common"
  }
}

data "azurerm_client_config" "current" {
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
    },
    {
      name                                           = var.private_endpoints_subnet_name
      address_prefixes                               = var.private_endpoints_subnet_address_prefix
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

resource "azurerm_role_assignment" "network_contributor" {
  scope                            = azurerm_resource_group.rg.id
  role_definition_name             = "Network Contributor"
  principal_id                     = module.aks.aks_identity_principal_id
  skip_service_principal_aad_check = true
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

module "sql_server_private_dns_zone" {
  source              = "./modules/private_dns_zone"
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_networks_to_link = {
    (module.network.name) = {
      subscription_id     = data.azurerm_client_config.current.subscription_id
      resource_group_name = azurerm_resource_group.rg.name
    }
  }
}

module "sql_server" {
  source                       = "./modules/sqlserver"
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  administrator_login          = var.sql_server_administrator_login
  administrator_login_password = var.sql_server_administrator_login_password
  databases                    = var.sql_server_databases
  firewall_rules               = var.sql_server_firewall_rules
  private_dns_zone_id          = module.sql_server_private_dns_zone.id
  private_endpoint_subnet_id   = module.network.subnet_ids[var.private_endpoints_subnet_name]
}

provider "kubernetes" {
  host                   = module.aks.host
  username               = module.aks.username
  password               = module.aks.password
  client_certificate     = module.aks.client_certificate
  client_key             = module.aks.client_key
  cluster_ca_certificate = module.aks.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    load_config_file       = false
    host                   = module.aks.host
    username               = module.aks.username
    password               = module.aks.password
    client_certificate     = module.aks.client_certificate
    client_key             = module.aks.client_key
    cluster_ca_certificate = module.aks.cluster_ca_certificate
  }
}

module "ingress_public_ip" {
  source              = "./modules/public_ip"
  name                = var.aks_ingress_public_ip_name
  domain_name_label   = "test-aks-ingress-hello-world"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_zone" "dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dns_cname_record" "ingress_dns_record" {
  name                = "test-aks-ingress-hello-world"
  resource_group_name = azurerm_resource_group.rg.name
  zone_name           = azurerm_dns_zone.dns_zone.name
  ttl                 = 900
  record              = module.ingress_public_ip.fqdn
}

module "nginx_ingress_controller" {
  source                   = "./modules/nginx_ingress_controller"
  ingress_class_name       = "ingress_nginx"
  namespace                = "ingress_nginx"
  load_balancer_ip_address = module.ingress_public_ip.ip_address
}

module "certificate_manager" {
  source                                = "./modules/cert_manager"
  namespace                             = "cert-manager"
  http_acme_resolver_ingress_class_name = module.nginx_ingress_controller.ingress_class_name
  lets_encrypt_cluster_issuer_name      = "letsencrypt-staging"
  lets_encrypt_private_key_secret_name  = "letsencrypt-staging"
  lets_encrypt_user_email               = "sukanya.pedavalli@gmail.com"
  lets_encrypt_server                   = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

