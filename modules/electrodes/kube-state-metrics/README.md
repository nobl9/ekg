# [kube-state-metrics](https://github.com/kubernetes/kube-state-metrics)

kube-state-metrics (KSM) is a simple service that listens
to the Kubernetes API server and generates metrics about the state of the objects. It is not focused on the health
of the individual Kubernetes components, but rather on the health of the various objects inside, such as deployments,
nodes and pods.

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
| [helm_release.electrode_kube-state-metrics](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of Helm Chart | `string` | `"4.29.0"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where Helm Chart will be installed | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
