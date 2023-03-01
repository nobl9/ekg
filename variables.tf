variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "eks_cluster_id" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "namespace" {
  type        = string
  default     = "ekg-monitoring"
  description = "Namespace where electrodes will be installed"
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Namespace speciefed by variable namespace will be created, if not exists"
}

variable "managed_prometheus_workspace_id" {
  description = "Amazon Managed Service for Prometheus Workspace IDAmazon Managed Service for Prometheus Workspace ID (when nothing passed new will be created)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
  type        = map(string)
  default     = {}
}
