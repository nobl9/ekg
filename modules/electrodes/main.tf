module "kube-state-metrics" {
  source = "./kube-state-metrics"
  count  = var.enable_kube-state-metrics ? 1 : 0

  namespace = var.namespace
}

module "kuberhealthy" {
  source = "./kuberhealthy"
  count  = var.enable_kuberhealthy ? 1 : 0

  namespace = var.namespace
}


module "node-problem-detector" {
  source = "./node-problem-detector"
  count  = var.enable_node-problem-detector ? 1 : 0

  namespace = var.namespace
}
