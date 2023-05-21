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

variable "vm_subnet_address_prefix" {
  description = "Specifies the address prefix of the VM subnet"
  type        = list(string)
}

variable "bastion_subnet_address_prefix" {
  description = "Specifies the address prefix of the bastion subnet"
  type        = list(string)
}

variable "bastion_host_name" {
  description = "(Optional) Specifies the name of the bastion host"
  type        = string
}