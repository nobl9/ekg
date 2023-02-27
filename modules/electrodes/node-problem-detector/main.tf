resource "helm_release" "electrode_node-problem-detector" {
  # https://github.com/kubernetes/node-problem-detector
  # https://github.com/deliveryhero/helm-charts/tree/master/stable/node-problem-detector
  name       = "node-problem-detector"
  repository = "https://charts.deliveryhero.io"
  chart      = "node-problem-detector"
  version    = var.chart_version

  namespace       = var.namespace
  wait            = true
  atomic          = true
  cleanup_on_fail = true

  values = [
    yamlencode({
      metrics = {
        enabled = true
      }
      resources = {
        requests = {
          memory = "128Mi"
          cpu    = "20m"
        }
        limits = {
          memory = "128Mi"
          cpu    = "300m"
        }
      }
    })
  ]
}
