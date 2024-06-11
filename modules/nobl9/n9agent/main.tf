data "aws_caller_identity" "this" {}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_id
}

locals {
  k8s_oidc_provider = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
}

resource "helm_release" "n9agent" {
  name       = "nobl9-agent"
  repository = "https://nobl9.github.io/helm-charts"
  chart      = "nobl9-agent"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      data_source_name      = var.data_source_name
      project_name          = var.project_name
      nobl9_organization_id = var.nobl9_organization_id
      client_id             = var.agent_client_id
      client_secret         = var.agent_client_secret
      service_account_name  = kubernetes_service_account.service_account.metadata[0].name
    })
  ]

  # Refer Namespace created separately to be able to clean it up with Terraform
  # https://github.com/hashicorp/terraform-provider-helm/issues/785#issuecomment-935332219
  namespace       = var.namespace
  wait            = true
  atomic          = true
  cleanup_on_fail = true
}

resource "aws_iam_role" "nobl9-ekg-ro" {
  name = "nobl9-ekg-ro-${var.cluster_id}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRoleWithWebIdentity"]
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:oidc-provider/${local.k8s_oidc_provider}"
        }
        Condition = {
          StringEquals = {
            "${local.k8s_oidc_provider}:sub" = "system:serviceaccount:${var.namespace}:nobl9-agent"
          }
        }
      }
    ]
  })
}

resource "kubernetes_service_account" "service_account" {
  metadata {
    name      = "nobl9-agent"
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.nobl9-ekg-ro.arn
    }
  }
}

data "aws_iam_policy_document" "nobl9-ekg-ro" {
  statement {
    effect    = "Allow"
    actions   = ["aps:QueryMetrics"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "nobl9-ekg-ro" {
  policy = data.aws_iam_policy_document.nobl9-ekg-ro.json
  role   = aws_iam_role.nobl9-ekg-ro.id
}