variable "namespace" {
  type        = string
  description = "Namespace where Helm Chart will be installed"
}

variable "chart_version" {
  type        = string
  default     = "1.0.4"
  description = "Version of Helm Chart"
}

variable "nobl9_organization_id" {
  description = "Nobl9 Organization ID (visible in Nobl9 web app under Settings > Account)"
  type        = string
}

variable "project_name" {
  description = "Name of the Nobl9 project to put these SLOs in"
  type        = string
}

variable "data_source_name" {
  description = "Name (ID) of the agent data source in Nobl9"
  type        = string
}

variable "agent_client_id" {
  description = "Client ID of the data source agent (from Nobl9 UI: Integrations > Sources > [your data source] > Agent Configuration)"
  type        = string
}

variable "agent_client_secret" {
  description = "Client Secret of the data source agent (from Nobl9 UI: Integrations > Sources > [your data source] > Agent Configuration)"
  type        = string
}
