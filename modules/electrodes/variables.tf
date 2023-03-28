
variable "namespace" {
  description = "Namespace where electrodes will be installed"
  type        = string
}

variable "enable_kube-state-metrics" {
  description = "Install kube-state-metrics"
  type        = bool
  default     = true
}

variable "enable_node-problem-detector" {
  description = "Install node-problem-detector"
  type        = bool
  default     = true
}

variable "enable_kuberhealthy" {
  description = "Install Kuberhealthy"
  type        = bool
  default     = true
}
