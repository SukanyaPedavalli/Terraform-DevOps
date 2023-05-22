resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.ns.metadata.0.name
  version    = "4.6.0"

  set {
    name  = "controller.service.loadBalancerIP"
    value = var.load_balancer_ip_address
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  set {
    name  = "controller.ingressClassResource.name"
    value = var.ingress_class_name
  }

  set {
    name  = "controller.ingressClassResource.controllerValue"
    value = "k8s.io/${var.ingress_class_name}"
  }

  set {
    name  = "controller.ingressClass"
    value = var.ingress_class_name
  }

  set {
    name  = "controller.replicaCount"
    value = var.replica_count
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  set {
    name = "controller.config.use-forwarded-headers"
    value = "true"
  }

  set {
    name = "controller.config.compute-full-forwarded-for"
    value = "true"
  }

  set {
    name = "controller.config.enable-real-ip"
    value = "true"
  }

  set {
    name  = "controller.resources.requests.cpu"
    value = var.cpu_requests
  }

  set {
    name  = "controller.resources.requests.memory"
    value = var.memory_requests
  }

  set {
    name  = "controller.autoscaling.enabled"
    value = true
  }

  set {
    name  = "controller.autoscaling.minReplicas"
    value = var.min_replicas
  }

  set {
    name  = "controller.autoscaling.maxReplicas"
    value = var.max_replicas
  }

  set {
    name  = "controller.autoscaling.targetCPUUtilizationPercentage"
    value = var.autoscaling_target_cpu_utilization_percentage
  }

  set {
    name  = "controller.autoscaling.targetMemoryUtilizationPercentage"
    value = var.autoscaling_target_memory_utilization_percentage
  }

  set {
    name  = "controller.metrics.enabled"
    value = true
  }

  set {
    name  = "controller.metrics.service.type"
    value = "ClusterIP"
  }
}
