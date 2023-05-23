terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">=1.14.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">=1.3.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.20.0"
    }
  }
}

locals {
  cluster_issuer = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name : var.lets_encrypt_cluster_issuer_name
    }
    spec = {
      acme = {
        email = var.lets_encrypt_user_email
        privateKeySecretRef = {
          name = var.lets_encrypt_private_key_secret_name
        }
        server = var.lets_encrypt_server
        solvers = [
          {
            http01 = {
              ingress = {
                class = var.http_acme_resolver_ingress_class_name
              }
            }
          }
        ]
      }
    }
  }
}



resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "jetstack_cert_manager" {
  name       = var.name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = kubernetes_namespace.ns.metadata.0.name
  version    = "v1.11.0"

  set {
    name  = "installCRDs"
    value = true
  }
}

resource "time_sleep" "wait" {
  create_duration = "60s"
  depends_on      = [helm_release.jetstack_cert_manager]
}

resource "kubectl_manifest" "clusterissuer_letsencrypt" {
  validate_schema = false
  yaml_body       = yamlencode(local.cluster_issuer)
  depends_on      = [kubernetes_namespace.ns, helm_release.jetstack_cert_manager, time_sleep.wait]
}
