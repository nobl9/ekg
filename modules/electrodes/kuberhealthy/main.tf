resource "helm_release" "this" {
  # https://github.com/kuberhealthy/kuberhealthy
  # https://github.com/kuberhealthy/kuberhealthy/tree/master/deploy/helm/kuberhealthy
  name       = "kuberhealthy"
  repository = "https://kuberhealthy.github.io/kuberhealthy/helm-repos"
  chart      = "kuberhealthy"
  version    = var.chart_version

  namespace       = var.namespace
  wait            = true
  atomic          = true
  cleanup_on_fail = true

  set {
    name  = "prometheus.enabled"
    value = true
  }
  # Default Chart's resource requests and limits are used.
}
