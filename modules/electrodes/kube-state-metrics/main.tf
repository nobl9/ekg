resource "helm_release" "electrode_kube-state-metrics" {
  # https://github.com/kubernetes/kube-state-metrics
  # https://artifacthub.io/packages/helm/prometheus-community/kube-state-metrics
  name       = "kube-state-metrics"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-state-metrics"
  version    = var.chart_version

  # Refer Namespace created separately to be able to cleanup it with Terraform
  # https://github.com/hashicorp/terraform-provider-helm/issues/785#issuecomment-935332219
  namespace       = var.namespace
  wait            = true
  atomic          = true
  cleanup_on_fail = true
}
