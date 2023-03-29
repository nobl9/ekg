variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "eks_cluster_id" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "namespace" {
  description = "Namespace where electrodes will be installed"
  type        = string
  default     = "ekg-monitoring"
}

variable "create_namespace" {
  description = "Namespace speciefed by variable namespace will be created, if not exists"
  type        = bool
  default     = true
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

variable "nobl9_organization_id" {
  description = "Nobl9 Organization ID (visible in Nobl9 web app under Settings > Account)"
  type        = string
}

variable "nobl9_project_name" {
  description = "Nobl9 Project name (create one in the Nobl9 web app using Catalog > Projects, or use 'default')"
  type        = string
  default     = "default"
}

variable "nobl9_client_id" {
  description = "Nobl9 Client ID (create in Nobl9 web app using Settings > Access Keys)"
  type        = string
  sensitive   = true
}

variable "nobl9_client_secret" {
  description = "Nobl9 Client Secret (create in Nobl9 web app using Settings > Access Keys)"
  type        = string
  sensitive   = true
}
