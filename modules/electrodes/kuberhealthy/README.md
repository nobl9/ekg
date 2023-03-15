# [Kuberhealthy](https://github.com/kuberhealthy/kuberhealthy)

Kuberhealthy performs synthetic monitoring and continuous process verification.
Kuberhealthy comes with lots of useful checks already available to ensure the core functionality of Kubernetes, but checks can
be used to test anything you like. Kuberhealthy lets you continuously verify that your applications and Kubernetes clusters are
working as expected.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of Helm Chart | `string` | `"92"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where Helm Chart will be installed | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
