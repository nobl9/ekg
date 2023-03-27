
variable "cluster_id" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "namespace" {
  type        = string
  description = "Namespace where electrodes will be installed"
}

variable "amp_ws_endpoint" {
  type        = string
  description = "Amazon Managed Prometheus endpoint"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "nobl9_organization_id" {
  description = "Nobl9 Organization ID (visible in Nobl9 web app under Settings > Account)"
  type        = string
}
