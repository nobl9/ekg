resource "nobl9_agent" "this" {
  name         = "ekg-amp-${replace(lower(var.cluster_id), " ", "-")}"
  display_name = "ekg-amp ${var.cluster_id}"
  project      = var.project_name
  source_of    = ["Metrics"]
  agent_type   = "amazon_prometheus"
  amazon_prometheus_config {
    url    = var.amp_ws_endpoint
    region = var.aws_region
  }
}
