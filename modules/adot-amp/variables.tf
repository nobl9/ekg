variable "eks_cluster_id" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "namespace" {
  type        = string
  description = "Namespace where it should be installed"
}

# Amazon Managed Prometheus

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
  type        = map(string)
  default     = {}
}

variable "managed_prometheus_workspace_id" {
  description = "Amazon Managed Service for Prometheus Workspace ID (when nothing passed new will be created)"
  type        = string
  default     = ""
}

variable "managed_prometheus_alias" {
  description = "Amazon Managed Service for Prometheus alias"
  type        = string
  default     = "adot"
}

variable "managed_prometheus_workspace_region" {
  description = "Region where Amazon Managed Service for Prometheus is deployed"
  type        = string
  default     = null
}

variable "enable_alertmanager" {
  description = "Creates Amazon Managed Service for Prometheus AlertManager for all workloads"
  type        = bool
  default     = false
}

variable "irsa_iam_role_path" {
  description = "IAM role path for IRSA roles"
  type        = string
  default     = "/"
}

variable "irsa_iam_permissions_boundary" {
  description = "IAM permissions boundary for IRSA roles"
  type        = string
  default     = ""
}

variable "enable_amazon_eks_adot" {
  description = "Enables the ADOT Operator on the EKS Cluster"
  type        = bool
  default     = true
}

variable "enable_cert_manager" {
  description = "Allow reusing an existing installation of cert-manager"
  type        = bool
  default     = true
}

variable "helm_config" {
  description = "Helm provider config for ADOT Operator AddOn"
  type        = any
  default     = {}
}

variable "prometheus_config" {
  description = "Controls default values such as scrape interval, timeouts and ports globally"
  type = object({
    global_scrape_interval = string
    global_scrape_timeout  = string
  })

  default = {
    global_scrape_interval = "15s"
    global_scrape_timeout  = "10s"
  }
  nullable = false
}

# https://github.com/aws-observability/aws-otel-collector/releases
variable "adot_collector_image" {
  type = object({
    repository = string
    tag        = string
    sha        = string
  })

  default = {
    repository = "public.ecr.aws/aws-observability/aws-otel-collector"
    tag        = "v0.25.0"
    sha        = ""
  }
  nullable = false
}
