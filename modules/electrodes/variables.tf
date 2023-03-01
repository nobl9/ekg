
variable "namespace" {
  type        = string
  description = "Namespace where electrodes will be installed"
}

variable "enable_kube-state-metrics" {
  type        = bool
  default     = true
  description = "Install kube-state-metrics"
}

variable "enable_node-problem-detector" {
  type        = bool
  default     = true
  description = "Install node-problem-detector"
}

variable "enable_kuberhealthy" {
  type        = bool
  default     = true
  description = "Install Kuberhealthy"
}
