resource "kubernetes_secret" "example" {
  metadata {
    name      = var.data_source_name
    namespace = var.namespace
  }

  data = {
    aws_access_key_id     = aws_iam_access_key.nobl9-ekg.id
    aws_secret_access_key = aws_iam_access_key.nobl9-ekg.secret
  }

  type = "Opaque"
}

resource "helm_release" "n9agent" {
  name = "nobl9-agent"
  # https://github.com/nobl9/helm-charts
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
    })
  ]

  # Refer Namespace created separately to be able to clean it up with Terraform
  # https://github.com/hashicorp/terraform-provider-helm/issues/785#issuecomment-935332219
  namespace       = var.namespace
  wait            = true
  atomic          = true
  cleanup_on_fail = true
}

resource "aws_iam_user" "nobl9-ekg" {
  name = "nobl9-ekg"
  path = "/"
}

resource "aws_iam_access_key" "nobl9-ekg" {
  user = aws_iam_user.nobl9-ekg.name
}

data "aws_iam_policy_document" "nobl9-ekg-ro" {
  statement {
    effect    = "Allow"
    actions   = ["aps:QueryMetrics"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "nobl9-ekg-ro" {
  name   = "nobl9-ekg"
  user   = aws_iam_user.nobl9-ekg.name
  policy = data.aws_iam_policy_document.nobl9-ekg-ro.json
}
