# Nobl9 EKG SLOs

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_nobl9"></a> [nobl9](#requirement\_nobl9) | 0.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nobl9"></a> [nobl9](#provider\_nobl9) | 0.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [nobl9_service.this](https://registry.terraform.io/providers/nobl9/nobl9/0.8.0/docs/resources/service) | resource |
| [nobl9_slo.cluster-readiness](https://registry.terraform.io/providers/nobl9/nobl9/0.8.0/docs/resources/slo) | resource |
| [nobl9_slo.control-plane-health](https://registry.terraform.io/providers/nobl9/nobl9/0.8.0/docs/resources/slo) | resource |
| [nobl9_slo.memory-headroom](https://registry.terraform.io/providers/nobl9/nobl9/0.8.0/docs/resources/slo) | resource |
| [nobl9_slo.node-health](https://registry.terraform.io/providers/nobl9/nobl9/0.8.0/docs/resources/slo) | resource |
| [nobl9_slo.workload-health](https://registry.terraform.io/providers/nobl9/nobl9/0.8.0/docs/resources/slo) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_error_rate_target"></a> [api\_error\_rate\_target](#input\_api\_error\_rate\_target) | SLO reliability target for apiserver error rate | `number` | `0.995` | no |
| <a name="input_api_latency_target"></a> [api\_latency\_target](#input\_api\_latency\_target) | SLO reliability target for apiserver latency | `number` | `0.995` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Name of the Kubernetes cluster | `string` | n/a | yes |
| <a name="input_data_source_name"></a> [data\_source\_name](#input\_data\_source\_name) | Name of the Nobl9 data source to query for SLIs (not the display name but the lowercase name (ID) with no spaces) | `string` | n/a | yes |
| <a name="input_data_source_project"></a> [data\_source\_project](#input\_data\_source\_project) | Name of the Nobl9 project in which the data source can be found | `string` | n/a | yes |
| <a name="input_ekg_display_prefix"></a> [ekg\_display\_prefix](#input\_ekg\_display\_prefix) | Prefix for Service and SLO objects in Nobl9 | `string` | `"🅴🅺🅶 "` | no |
| <a name="input_enable_kube_state_metrics_slos"></a> [enable\_kube\_state\_metrics\_slos](#input\_enable\_kube\_state\_metrics\_slos) | Would you like to include SLOs that rely on kube-state-metrics? | `bool` | n/a | yes |
| <a name="input_enable_kuberhealthy_slos"></a> [enable\_kuberhealthy\_slos](#input\_enable\_kuberhealthy\_slos) | Would you like to include SLOs that rely on Kuberhealthy metrics? | `bool` | n/a | yes |
| <a name="input_enable_node_problem_detector_slos"></a> [enable\_node\_problem\_detector\_slos](#input\_enable\_node\_problem\_detector\_slos) | Would you like to include SLOs that rely on node-problem-detector? | `bool` | n/a | yes |
| <a name="input_kuberhealthy_pod_start_latency"></a> [kuberhealthy\_pod\_start\_latency](#input\_kuberhealthy\_pod\_start\_latency) | Allowable duration of Kuberhealthy check | `number` | `180` | no |
| <a name="input_kuberhealthy_pod_start_latency_target"></a> [kuberhealthy\_pod\_start\_latency\_target](#input\_kuberhealthy\_pod\_start\_latency\_target) | SLO reliability target for Kuberhealthy pod start latency | `number` | `0.99` | no |
| <a name="input_kuberhealthy_pod_start_success_target"></a> [kuberhealthy\_pod\_start\_success\_target](#input\_kuberhealthy\_pod\_start\_success\_target) | SLO reliability target for Kuberhealthy pod start success | `number` | `0.995` | no |
| <a name="input_memory_headroom_target"></a> [memory\_headroom\_target](#input\_memory\_headroom\_target) | SLO reliability target for memory headroom | `number` | `0.99` | no |
| <a name="input_memory_headroom_threshold"></a> [memory\_headroom\_threshold](#input\_memory\_headroom\_threshold) | Maximum allowable memory consumption (fraction of 1.0) | `number` | `0.9` | no |
| <a name="input_memory_utilization_target"></a> [memory\_utilization\_target](#input\_memory\_utilization\_target) | SLO reliability target for memory utilization | `number` | `0.99` | no |
| <a name="input_memory_utilization_threshold"></a> [memory\_utilization\_threshold](#input\_memory\_utilization\_threshold) | Minimum allowable memory consumption (fraction of 1.0) | `number` | `0.7` | no |
| <a name="input_node_not_ready_target"></a> [node\_not\_ready\_target](#input\_node\_not\_ready\_target) | SLO reliability target for node not ready | `number` | `0.99` | no |
| <a name="input_node_not_ready_threshold"></a> [node\_not\_ready\_threshold](#input\_node\_not\_ready\_threshold) | Maximum allowable number of nodes in a non-ready state | `number` | `0` | no |
| <a name="input_node_problem_target"></a> [node\_problem\_target](#input\_node\_problem\_target) | SLO reliability target for node problems | `number` | `0.99` | no |
| <a name="input_node_problem_threshold"></a> [node\_problem\_threshold](#input\_node\_problem\_threshold) | Number of nodes problems that is considered a problem for the cluster | `number` | `1` | no |
| <a name="input_phase_failed_unknown_target"></a> [phase\_failed\_unknown\_target](#input\_phase\_failed\_unknown\_target) | SLO reliability target for not having pods in a bad state (failed or unknown) | `number` | `0.99` | no |
| <a name="input_phase_failed_unknown_threshold"></a> [phase\_failed\_unknown\_threshold](#input\_phase\_failed\_unknown\_threshold) | This many pods in a bad state (failed or unknown) is considered a failing workload | `number` | `1` | no |
| <a name="input_phase_pending_target"></a> [phase\_pending\_target](#input\_phase\_pending\_target) | SLO reliability target for not having pods in a pending state | `number` | `0.99` | no |
| <a name="input_phase_pending_threshold"></a> [phase\_pending\_threshold](#input\_phase\_pending\_threshold) | Maximum allowable number of pods in a pending state | `number` | `0` | no |
| <a name="input_phase_running_target"></a> [phase\_running\_target](#input\_phase\_running\_target) | SLO reliability target for having enough things running in the cluster | `number` | `0.99` | no |
| <a name="input_phase_running_threshold"></a> [phase\_running\_threshold](#input\_phase\_running\_threshold) | Minimum allowable ratio of pods that should be running | `number` | `0.7` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the Nobl9 project to put these SLOs in | `string` | n/a | yes |
| <a name="input_rolling_window_days"></a> [rolling\_window\_days](#input\_rolling\_window\_days) | Evaluation time period for EKG SLOs | `number` | `7` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->