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

resource "kubernetes_manifest" "clusterissuer_letsencrypt" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name : var.lets_encrypt_cluster_issuer_name
    }
    spec = {
      acme = {
        email = var.lets_encrypt_user_email
        privateKetSecretRef = {
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
