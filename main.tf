provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_id
}

data "aws_eks_cluster" "this" {
  name = var.eks_cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}


resource "kubernetes_namespace" "this" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

module "adot_amp" {
  source = "./modules/adot-amp"

  eks_cluster_id = var.eks_cluster_id
  namespace      = var.namespace
  tags           = var.tags

  managed_prometheus_workspace_id = var.managed_prometheus_workspace_id

  depends_on = [
    kubernetes_namespace.this
  ]
}

module "electrodes" {
  source = "./modules/electrodes"

  namespace = var.namespace

  depends_on = [
    kubernetes_namespace.this
  ]
}
