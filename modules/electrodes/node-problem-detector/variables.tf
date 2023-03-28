variable "namespace" {
  description = "Namespace where Helm Chart will be installed"
  type        = string
}

variable "chart_version" {
  description = "Version of Helm Chart"
  type        = string
  default     = "2.3.3"
}
