variable "namespace" {
  description = "(Optional) The namespace in which to deploy the cert-manager"
  type        = string
}

variable "name" {
  description = "(Optional) the name of the helm release for the cert-manager"
  type        = string
  default     = "jetstack-cert-manager"
}

variable "lets_encrypt_cluster_issuer_name" {
  description = "(Required) The name of the cluster issuer resource to be created."
  type        = string
}

variable "lets_encrypt_user_email" {
  description = "(Required) The user email address to be listed for the lets encrypt"
  type        = string
}

variable "lets_encrypt_private_key_secret_name" {
  description = "(Required) The name of the secrets to be used by the certmanager to store the private key of the lets encrypt"
  type        = string
}

variable "lets_encrypt_server" {
  description = "(Optional) The lets encrypt server to use."
  type        = string
  default     = ""
}

variable "http_acme_resolver_ingress_class_name" {
  description = "(Required) The ingress class name of the ingress controller used to resolve the http acme challenge"
  type        = string
}
