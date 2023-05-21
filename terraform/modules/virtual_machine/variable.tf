variable resource_group_name {
  description = "(Required) Specifies the resource group name of the virtual machine"
  type = string
}

variable name {
  description = "(Required) Specifies the name of the virtual machine"
  type = string
}

variable size {
  description = "(Required) Specifies the size of the virtual machine"
  type = string
}

variable "os_disk_image" {
  type        = map(string)
  description = "(Optional) Specifies the os disk image of the virtual machine"
  default     = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS" 
    version   = "latest"
  }
}

variable "os_disk_storage_account_type" {
  description = "(Optional) Specifies the storage account type of the os disk of the virtual machine"
  default     = "StandardSSD_LRS"
  type        = string

  validation {
    condition = contains(["Premium_LRS", "Premium_ZRS", "StandardSSD_LRS", "StandardSSD_ZRS",  "Standard_LRS"], var.os_disk_storage_account_type)
    error_message = "The storage account type of the OS disk is invalid."
  }
}

variable location {
  description = "(Required) Specifies the location of the virtual machine"
  type = string
}

variable subnet_id {
  description = "(Required) Specifies the resource id of the subnet hosting the virtual machine"
  type        = string
}

variable vm_user {
  description = "(Required) Specifies the username of the virtual machine"
  type        = string
  default     = "azadmin"
}

variable boot_diagnostics_storage_account {
  description = "(Optional) The Primary/Secondary Endpoint for the Azure Storage Account (general purpose) which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor."
  default     = null
}

variable admin_ssh_public_key {
  description = "Specifies the public SSH key"
  type        = string
}

variable bastion_subnet_address_prefix {
  description = "(Required) The address prefix of the bastion host used to connect to the virtual machine"
  type = string
}

variable tags {
  description = "(Optional) The tags that need to be attached to the resources"
  default = {}
}