resource "nobl9_project" "this" {
  display_name = "EKG"
  name         = "ekg"
  description  = "Essential Kubernetes Gauges -- maintain via terraform"
}


module "data_source" {
  source = "./data-source"
  project_name = nobl9_project.this.name
  cluster_id = var.cluster_id
  aws_region = var.aws_region
  amp_ws_endpoint = var.amp_ws_endpoint
}

module "n9agent" {
  source = "./n9agent"
  nobl9_organization_id = var.nobl9_organization_id
  project_name = nobl9_project.this.name
  data_source_name = module.data_source.data_source_name
  namespace = var.namespace
  agent_client_id = module.data_source.client_id
  agent_client_secret = module.data_source.client_secret
}

module "slos" {
  source = "./slos"
  project_name = nobl9_project.this.name

  # cluster settings
  cluster_id = var.cluster_id

  # nobl9 data source
  data_source_name = module.data_source.data_source_name
  data_source_project = nobl9_project.this.name

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
