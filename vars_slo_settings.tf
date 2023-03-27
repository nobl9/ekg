# SLO adjustable settings

variable "rolling_window_days" {
  description = "Evaluation time period for EKG SLOs"
  type        = number
}

variable "enable_kuberhealthy_slos" {
  type        = bool
  description = "Would you like to include SLOs that rely on kuberhealthy metrics?"
}

variable "kuberhealthy_pod_start_latency" {
  type        = number
  description = "Allowable duration of kuberhealthy check"
}

variable "kuberhealthy_pod_start_latency_target" {
  type        = number
  description = "SLO reliability target for kuberhealthy pod start latency"

}

variable "kuberhealthy_pod_start_success_target" {
  type        = number
  description = "SLO reliability target for kuberhealthy pod start success"
}

variable "enable_kube_state_metrics_slos" {
  type        = bool
  description = "Would you like to include SLOs that rely on kube-state-metrics?"
}

variable "memory_headroom_target" {
  type        = number
  description = "SLO reliability target for memory headroom"
}

variable "memory_headroom_threshold" {
  type        = number
  description = "Maximum allowable memory consumption (fraction of 1.0)"
}

variable "memory_utilization_target" {
  type        = number
  description = "SLO reliability target for memory utilization"
}

variable "memory_utilization_threshold" {
  type        = number
  description = "Minimum allowable memory consumption (fraction of 1.0)"
}

variable "phase_running_target" {
  type        = number
  description = "SLO reliability target for having enough things running in the cluster"
}

variable "phase_running_threshold" {
  type        = number
  description = "Minimum allowable ratio of pods that should be running"
}

variable "phase_failed_unknown_target" {
  type        = number
  description = "SLO reliability target for not having pods in a bad state (failed or unknown)"
}

variable "phase_failed_unknown_threshold" {
  type        = number
  description = "This many pods in a bad state (failed or unknown) is considered a failing workload"
}

variable "phase_pending_target" {
  type        = number
  description = "SLO reliability target for not having pods in a pending state"
}

variable "phase_pending_threshold" {
  type        = number
  description = "Maximum allowable number of pods in a pending state"
}

variable "api_error_rate_target" {
  type        = number
  description = "SLO reliability target for apiserver error rate"
}

variable "api_latency_target" {
  type        = number
  description = "SLO reliability target for apiserver latency"
}

variable "enable_node_problem_detector_slos" {
  type        = bool
  description = "Would you like to include SLOs that rely on node-problem-detector?"
}

variable "node_problem_target" {
  type        = number
  description = "SLO reliability target for node problems"
}

variable "node_problem_threshold" {
  type        = number
  description = "Number of nodes problems that is considered a problem for the cluster"
}

variable "node_not_ready_target" {
  type        = number
  description = "SLO reliability target for node not ready"
}

variable "node_not_ready_threshold" {
  type        = number
  description = "Maximum allowable number of nodes in a non-ready state"
}
