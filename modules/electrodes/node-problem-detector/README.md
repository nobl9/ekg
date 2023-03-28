# [node-problem-detector](https://github.com/kubernetes/node-problem-detector)

node-problem-detector aims to make various node problems visible
to the upstream layers in the cluster management stack. It is a daemon that runs on each node, detects node problems
and exposes metrics about them.

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
| [helm_release.electrode_node-problem-detector](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of Helm Chart | `string` | `"2.3.4"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where Helm Chart will be installed | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
