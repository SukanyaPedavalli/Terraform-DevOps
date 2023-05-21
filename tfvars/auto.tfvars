resource_group_name           = "TestRG"
location                      = "eastus"
vnet_name                     = "VNet"
vnet_address_space            = ["10.0.0.0/16"]
vm_subnet_address_prefix      = ["10.0.0.0/24"]
bastion_subnet_address_prefix = ["10.0.1.0/24"]
bastion_host_name             = "BaboBastionHost"
storage_account_iprules       = ["75.60.207.196"]
