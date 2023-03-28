# SLO adjustable settings

variable "rolling_window_days" {
  description = "Evaluation time period for EKG SLOs"
  type        = number
}

variable "enable_kuberhealthy_slos" {
  description = "Would you like to include SLOs that rely on kuberhealthy metrics?"
  type        = bool
}

variable "kuberhealthy_pod_start_latency" {
  description = "Allowable duration of kuberhealthy check"
  type        = number
}

variable "kuberhealthy_pod_start_latency_target" {
  description = "SLO reliability target for kuberhealthy pod start latency"
  type        = number
}

variable "kuberhealthy_pod_start_success_target" {
  description = "SLO reliability target for kuberhealthy pod start success"
  type        = number
}

variable "enable_kube_state_metrics_slos" {
  description = "Would you like to include SLOs that rely on kube-state-metrics?"
  type        = bool
}

variable "memory_headroom_target" {
  description = "SLO reliability target for memory headroom"
  type        = number
}

variable "memory_headroom_threshold" {
  description = "Maximum allowable memory consumption (fraction of 1.0)"
  type        = number
}

variable "memory_utilization_target" {
  description = "SLO reliability target for memory utilization"
  type        = number
}

variable "memory_utilization_threshold" {
  description = "Minimum allowable memory consumption (fraction of 1.0)"
  type        = number
}

variable "phase_running_target" {
  description = "SLO reliability target for having enough things running in the cluster"
  type        = number
}

variable "phase_running_threshold" {
  description = "Minimum allowable ratio of pods that should be running"
  type        = number
}

variable "phase_failed_unknown_target" {
  description = "SLO reliability target for not having pods in a bad state (failed or unknown)"
  type        = number
}

variable "phase_failed_unknown_threshold" {
  description = "This many pods in a bad state (failed or unknown) is considered a failing workload"
  type        = number
}

variable "phase_pending_target" {
  description = "SLO reliability target for not having pods in a pending state"
  type        = number
}

variable "phase_pending_threshold" {
  description = "Maximum allowable number of pods in a pending state"
  type        = number
}

variable "api_error_rate_target" {
  description = "SLO reliability target for apiserver error rate"
  type        = number
}

variable "api_latency_target" {
  description = "SLO reliability target for apiserver latency"
  type        = number
}

variable "enable_node_problem_detector_slos" {
  description = "Would you like to include SLOs that rely on node-problem-detector?"
  type        = bool
}

variable "node_problem_target" {
  description = "SLO reliability target for node problems"
  type        = number
}

variable "node_problem_threshold" {
  description = "Number of nodes problems that is considered a problem for the cluster"
  type        = number
}

variable "node_not_ready_target" {
  description = "SLO reliability target for node not ready"
  type        = number
}

variable "node_not_ready_threshold" {
  description = "Maximum allowable number of nodes in a non-ready state"
  type        = number
}
