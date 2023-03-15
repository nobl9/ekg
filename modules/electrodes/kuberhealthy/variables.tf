variable "namespace" {
  type        = string
  description = "Namespace where Helm Chart will be installed"
}

variable "chart_version" {
  type        = string
  default     = "92"
  description = "Version of Helm Chart"
}