provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster" "this" {
  name = var.eks_cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "nobl9" {
  organization  = var.nobl9_organization_id
  project       = var.nobl9_project_name
  client_id     = var.nobl9_client_id
  client_secret = var.nobl9_client_secret
}

resource "kubernetes_namespace" "this" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

module "adot_amp" {
  source = "./modules/adot-amp"

  eks_cluster_id = var.eks_cluster_id
  namespace      = var.namespace
  tags           = var.tags

  managed_prometheus_workspace_id = var.managed_prometheus_workspace_id

  depends_on = [
    kubernetes_namespace.this
  ]
}

module "electrodes" {
  source = "./modules/electrodes"

  namespace = var.namespace

  depends_on = [
    kubernetes_namespace.this
  ]
}

module "nobl9" {
  source = "./modules/nobl9"
  cluster_id = var.eks_cluster_id
  namespace      = var.namespace
  aws_region = var.aws_region
  amp_ws_endpoint = module.adot_amp.amp_ws_endpoint
  nobl9_organization_id = var.nobl9_organization_id

  # pass through variables for SLO adjustable settings
  enable_kube_state_metrics_slos = var.enable_kube_state_metrics_slos
  enable_kuberhealthy_slos = var.enable_kuberhealthy_slos
  enable_node_problem_detector_slos = var.enable_node_problem_detector_slos
  rolling_window_days = var.rolling_window_days
  kuberhealthy_pod_start_latency = var.kuberhealthy_pod_start_latency
  kuberhealthy_pod_start_latency_target = var.kuberhealthy_pod_start_latency_target
  kuberhealthy_pod_start_success_target = var.kuberhealthy_pod_start_success_target
  api_error_rate_target = var.api_error_rate_target
  api_latency_target = var.api_latency_target
  memory_headroom_target = var.memory_headroom_target
  memory_headroom_threshold = var.memory_headroom_threshold
  memory_utilization_target = var.memory_utilization_target
  memory_utilization_threshold = var.memory_utilization_threshold
  node_problem_target = var.node_problem_target
  node_problem_threshold = var.node_problem_threshold
  node_not_ready_target = var.node_not_ready_target
  node_not_ready_threshold = var.node_not_ready_threshold
  phase_running_target = var.phase_running_target
  phase_running_threshold = var.phase_running_threshold
  phase_failed_unknown_target = var.phase_failed_unknown_target
  phase_failed_unknown_threshold = var.phase_failed_unknown_threshold
  phase_pending_target = var.phase_pending_target
  phase_pending_threshold = var.phase_pending_threshold

}
