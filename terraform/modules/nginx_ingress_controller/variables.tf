variable "namespace" {
  description = "(Required) The namespace in which to deploy the nginx ingress controller"
  type        = string
}

variable "load_balancer_ip_address" {
  description = "(Required) The loadbalancer ipaddress for the ingress controller"
  type        = string
}

variable "ingress_class_name" {
  description = "(Required) The ingress class to listen to the ingress controller"
  type        = string
}

variable "replica_count" {
  description = "(Optional) The replica count of the ingress controller pods"
  type        = number
  default     = 2
}

variable "cpu_requests" {
  description = "(Optional) The resource requests for cpu for the ingress controller pods"
  type        = string
  default     = "1.0"
}

variable "memory_requests" {
  description = "(Optional) The resource requests for memory of the ingress controller pods"
  type        = string
  default     = "1Gi"
}

variable "min_replicas" {
  description = "(Optional) The minimum number of replicas to be present as part of the autoscaling"
  type        = number
  default     = 2
}

variable "max_replicas" {
  description = "(Optional) The maximum number of replicas to which the ingress controller pods can scale"
  type        = number
  default     = 5
}

variable "autoscaling_target_cpu_utilization_percentage" {
  description = "(Optional) The target cpu utilization percentage that should trigger scaling."
  type        = number
  default     = 70
}

variable "autoscaling_target_memory_utilization_percentage" {
  description = "(Optional) The target memory utilization percentage that should trigger scaling."
  type        = number
  default     = 70
}
