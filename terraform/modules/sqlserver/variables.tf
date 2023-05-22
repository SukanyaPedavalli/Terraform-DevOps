variable "name" {
  description = "(Required) The name of the sql server"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The Resource group name in which the sql server is created"
  type        = string
}

variable "location" {
  description = "(Required) Specifies the location in which the sqlserver instance is deployed."
  type        = string
}

variable "administrator_login" {
  description = "(Required) Specifies the login username for the administrator"
  type        = string
  default     = "azadmin"
}

variable "administrator_login_password" {
  description = "(Required) Specifies the login password for the administrator"
  type        = string
}

variable "databases" {
  description = "(Required) specifies the list of databases to be created"
  type        = list(string)
}

variable "firewall_rules" {
  description = "Firewall rules for the sql server"
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
}

variable "private_endpoint_subnet_id" {
  description = "(Required) the subnet id in which the private endpoint nic need to be created to."
  type        = string
}

variable "private_dns_zone_id" {
  description = "(Required) The resource identifier of the Private DNSZone in which the dns records need to be created at."
  type        = string
}

variable "tags" {
  description = "(Optional) Tags that need to be applied to the resource"
  default     = {}
}

variable "enable_public_network_access" {
  description = "(Optional) Determines whether public network access need to be enabled for the sql server"
  type        = bool
  default     = true
}
