resource "kubernetes_namespace" "argocd" {
  metadata { name = "argocd" }
}

resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "6.8.1"

  values = [yamlencode({
    fullnameOverride = "argocd"
    server = {
      service = { type = "ClusterIP" }
      ingress = {
        enabled          = true
        ingressClassName = "nginx"
        hosts            = ["argocd.student1.devops1.test-danit.com"]
        paths            = ["/"]
        pathType         = "Prefix"
        annotations = {
          "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
        }
      }
    }
    configs = {
      params = { "server.insecure" = true } 
    }
  })]

  depends_on = [helm_release.nginx_ingress]
}
