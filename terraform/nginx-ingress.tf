resource "kubernetes_namespace" "ingress_nginx" {
  metadata { name = "ingress-nginx" }
}

resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name
  version    = "4.11.1"

  values = [yamlencode({
    controller = {
      replicaCount = 1
      service = {
        type = "LoadBalancer"
      }
      metrics = { enabled = true }
    }
  })]

  depends_on = [module.eks]
}
