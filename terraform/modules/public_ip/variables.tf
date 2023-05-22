variable "name" {
  description = "(Required) Specifies the name of the public ip address"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the resource group in which to deploy the public ip address"
  type        = string
}

variable "location" {
  description = "(Required) The azure region in which to deploy the public ip address"
  type        = string
}

variable "allocation_method" {
  description = "(Optional) The ip address allocation method defaults to static"
  type        = string
  default     = "Static"
}

variable "domain_name_label" {
  description = "(Optional) the domain name label to be used for the public ip address."
  type        = string
}
