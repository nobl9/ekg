variable "amp_ws_endpoint" {
  description = "Amazon Managed Prometheus endpoint"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "project_name" {
  description = "Name of the Nobl9 project to put the data source in"
  type        = string
}

variable "cluster_id" {
  description = "Name of the Kubernetes cluster"
  type        = string
}
