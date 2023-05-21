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

variable "vm_subnet_name" {
  description = "(Required) Specifies the name of the subnet name of the VM."
  type        = string
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

variable "storage_account_kind" {
  description = "(Optional) Specifies the account kind of the storage account"
  default     = "StorageV2"
  type        = string

  validation {
    condition     = contains(["Storage", "StorageV2"], var.storage_account_kind)
    error_message = "The account kind of the storage account is invalid."
  }
}

variable "storage_account_tier" {
  description = "(Optional) Specifies the account tier of the storage account"
  default     = "Standard"
  type        = string

  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "The account tier of the storage account is invalid."
  }
}

variable "storage_account_iprules" {
  description = "(Optional) Specifies the list of Ip Addresses whitelisted to access the storage account"
  default     = []
  type        = list(string)
}

variable "vm_name" {
  description = "Specifies the name of the virtual machine"
  default     = "TestVm"
  type        = string
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine"
  default     = "Standard_DS1_v2"
  type        = string
}

variable "vm_os_disk_storage_account_type" {
  description = "Specifies the storage account type of the os disk of the virtual machine"
  default     = "Premium_LRS"
  type        = string

  validation {
    condition     = contains(["Premium_LRS", "Premium_ZRS", "StandardSSD_LRS", "StandardSSD_ZRS", "Standard_LRS"], var.vm_os_disk_storage_account_type)
    error_message = "The storage account type of the OS disk is invalid."
  }
}

variable "vm_os_disk_image" {
  type        = map(string)
  description = "Specifies the os disk image of the virtual machine"
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
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
