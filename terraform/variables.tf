variable "resource_group_name" {
  description = "Specifies the resource group name"
  type        = string
}

variable "location" {
  description = "Specifies the location for the resource group and all the resources"
  default     = "eastus"
  type        = string
}

variable "vnet_name" {
  description = "Specifies the name of the hub virtual virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Specifies the address space of the hub virtual virtual network"
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "(Required) Specifies the name of the subnet name of the VM."
  type        = string
}

variable "aks_subnet_address_prefix" {
  description = "Specifies the address prefix of the VM subnet"
  type        = list(string)
}

variable "aks_name" {
  description = "Specifies the name of the virtual machine"
  default     = "TestVm"
  type        = string
}

variable "default_node_pool_vm_size" {
  description = "Specifies the vm size of the default node pool"
  type        = string
}

variable "agent_node_pool_vm_size" {
  description = "Specifies the vm size of the agent node pool"
  type        = string
}

variable "admin_username" {
  description = "(Required) Specifies the admin username of the jumpbox virtual machine and AKS worker nodes."
  type        = string
  default     = "azadmin"
}

variable "ssh_public_key" {
  description = "(Required) Specifies the SSH public key for the jumpbox virtual machine and AKS worker nodes."
  type        = string
}
