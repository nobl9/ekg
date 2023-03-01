# Electrodes

Install Helm Charts for gathering useful metrics on your Kubernetes cluster that can bu used
for defining meaningful SLOs. By default all electrodes are enabled and expose metrics.
Electrodes can be used with any Kubernetes cluster - EKS, GKE, on-premise, etc.

Electrodes

- [kube-state-metrics](./kube-state-metrics/README.md) - metrics for the health of the various objects inside, such as deployments, nodes and pods
- [node-problem-detector](./node-problem-detector/README.md) - metrics for the health of the node e.g. infrastructure daemon issues: ntp service down, hardware issues e.g. bad CPU, memory or disk, kernel issues e.g. kernel deadlock, corrupted file system, container runtime issues e.g. unresponsive runtime daemon
- [Kuberhealthy](./kuberhealthy/README.md) - metrics for the health of the cluster, performs synthetic tests that ensures daemonsets, deployments can be deployed, DNS resolves names, etc.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kube-state-metrics"></a> [kube-state-metrics](#module\_kube-state-metrics) | ./kube-state-metrics | n/a |
| <a name="module_kuberhealthy"></a> [kuberhealthy](#module\_kuberhealthy) | ./kuberhealthy | n/a |
| <a name="module_node-problem-detector"></a> [node-problem-detector](#module\_node-problem-detector) | ./node-problem-detector | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_kube-state-metrics"></a> [enable\_kube-state-metrics](#input\_enable\_kube-state-metrics) | Install kube-state-metrics | `bool` | `true` | no |
| <a name="input_enable_kuberhealthy"></a> [enable\_kuberhealthy](#input\_enable\_kuberhealthy) | Install Kuberhealthy | `bool` | `true` | no |
| <a name="input_enable_node-problem-detector"></a> [enable\_node-problem-detector](#input\_enable\_node-problem-detector) | Install node-problem-detector | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where electrodes will be installed | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
