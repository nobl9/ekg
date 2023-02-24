module "operator" {
  # https://github.com/aws-observability/terraform-aws-observability-accelerator
  source = "github.com/aws-observability/terraform-aws-observability-accelerator//modules/eks-monitoring/add-ons/adot-operator?ref=v2.0.0"

  count = var.enable_amazon_eks_adot ? 1 : 0

  enable_cert_manager = var.enable_cert_manager
  kubernetes_version  = local.eks_cluster_version
  addon_context       = local.context
}

resource "aws_prometheus_workspace" "this" {
  count = local.amp_ws_create ? 1 : 0

  alias = var.managed_prometheus_alias
  tags  = var.tags
}

resource "aws_prometheus_alert_manager_definition" "this" {
  count = var.enable_alertmanager ? 1 : 0

  workspace_id = local.amp_ws_id

  definition = <<EOF
alertmanager_config: |
    route:
      receiver: 'default'
    receivers:
      - name: 'default'
EOF
}

module "helm_addon" {
  # https://github.com/aws-ia/terraform-aws-eks-blueprints
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=v4.20.0"
  depends_on = [
    module.operator
  ]
  helm_config = merge(
    {
      name        = local.collector_name
      chart       = "${path.module}/adot-collector-helm-chart"
      version     = "0.2.0"
      namespace   = local.collector_namespace
      description = "AWS OTEL collector Helm Chart deployment configuration"
    },
    var.helm_config
  )

  set_values = [
    {
      name  = "image.repository"
      value = var.adot_collector_image.repository
    },
    {
      name  = "image.tag"
      value = var.adot_collector_image.tag
    },
    {
      name  = "image.sha"
      value = var.adot_collector_image.sha
    },
    {
      name  = "ampurl"
      value = "${local.amp_ws_endpoint}api/v1/remote_write"
    },
    {
      name  = "globalScrapeInterval"
      value = var.prometheus_config.global_scrape_interval
    },
    {
      name  = "globalScrapeTimeout"
      value = var.prometheus_config.global_scrape_timeout
    },
  ]

  irsa_config = {
    kubernetes_namespace        = local.collector_namespace
    create_kubernetes_namespace = false
    kubernetes_service_account  = try(var.helm_config.service_account, local.collector_name)
    irsa_iam_policies           = ["arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonPrometheusRemoteWriteAccess"]
  }

  addon_context = local.context
}
