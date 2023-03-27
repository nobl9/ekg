# Nobl9 EKG Service Level Objectives

EKG's SLOs are modularized, allowing you to adjust each SLO to the particular needs of each of your clusters. If you
installed all of EKG, you can adjust the settings of all of the SLOs by editing your terraform.tfvars from the root of
this repository.

The EKG SLOs are also available as a separate module from this subdirectory, in case you'd like to use them outside of
the context of the rest of the EKG. They accept variables that allow you to install them against any Prometheus or
compatible data source. (Nobl9 supports not only [Amazon's managed flavor](https://docs.nobl9.com/Sources/Amazon_Prometheus/)
but also [other flavors](https://docs.nobl9.com/Sources/prometheus/) of Prometheus and compatible metrics data sources.)
These SLOs are intended to be compatible with EKS, though they should be portable to any distribution or flavor of
Kubernetes. As long as you install the prerequisite or compatible metrics instrumentation (which we call
[electrodes](../electrodes)) they should work.

When working with SLOs, targets (SLO adherence -- the "nines" of reliability) and thresholds (for SLOs which use them,
the bounds that we hope that our metrics stay within) can be adjusted. If you tune your SLOs by adjusting these values,
your SLOs can alert you when something has changed, either because something has gone wrong in the platform or workload,
or simply that the environment has changed (for example, the traffic pattern of the workload has changed). We encourage
you to experiment with your SLOs, tuning them to fence the desirable behavior of your hosting platform (your clusters)
and providing you with a flexible and ergonomic management tool.

We welcome additions to EKG or suggestions on what you would like to see monitored by EKG. Please log an issue if you
have any ideas. It helps us especially if you can describe a failure mode you have experienced in your clusters that EKG
does not currently detect. If you'd like to contribute directly to EKG, please see
the [contribution guidelines](../../CONTRIBUTING.md).

EKG provides the following SLOs:

## Cluster Readiness

The Cluster Readiness SLO measures the end-to-end ability to start new workloads in the cluster. It is based on the
[Kuberhealthy](https://github.com/kuberhealthy/kuberhealthy) synthetics framework and
[part of CNCF](https://www.cncf.io/projects/kuberhealthy/). This SLO is intended as an overarching functional test of
the cluster's health.

EKG's Cluster Readness SLO measures Kuberhealthy's Deployment check.

### Pod start lag

This objective measures how long it takes for the Deployment check to run. If this check takes too long to run, this SLO
will burn budget.

If this objective exhausts its error budget, consider why it's taking so long to launch a new deployment in this
cluster. There is likely some kind of problem with the cluster. If you'd like a tighter or looser SLO, you can adjust the
settings by modifying:

`kuberhealthy_pod_start_latency` - The allowable time to complete the check (launch a deployment), in seconds
`kuberhealthy_pod_start_latency_target` - How reliably you need this cluster to launch a workload so quickly

### Pod start failure

This measures how often the Kuberhealthy deployment check fails. Whenever the deployment fails to start, this SLO will
burn budget.

If this objective exhausts its error budget, consider why the cluster is not able to launch a new deployment. Something
is likely wrong that is preventing this. If you'd like a tighter or looser SLO, you can adjust the settings by
modifying:

`kuberhealthy_pod_start_success_target` - How reliably you need this cluster to be able to successfully launch a new
workload

## Control Plane Health

The Kubernetes SIG-Scalability has published
[standard SLOs for the Kubernetes API](https://github.com/kubernetes/community/blob/master/sig-scalability/slos/slos.md)
and this EKG SLO is inspired by them. The motivation behind this SLO is to make sure that the API is responding
performantly and without too many errors.

### High error rate

If this objective exhausts its error budget, the Kubernetes API is erroring out, and something could be seriously wrong
with Kubernetes itself. In a managed Kubernetes environment (including for example EKS) this should be a rare
occurrence, however, it's possible to break managed Kubernetes, including by administrative actions, especially if
demand for the Kubernetes API itself spikes suddenly or something in the workload is putting high pressure on the API.
That said, a small number of errors is normal for most clusters and is likely acceptable for most clusters and
workloads -- hence the utility of giving it some allowance in the form of an error budget.

You can adjust this objective by modifying:
`api_error_rate_target` - How reliably you expect the Kubernetes API to not terminate the request and to respond with
a good status code

### Slow response time

If this objective exhausts its error budget, the Kubernetes API is responding too slowly, and something could be wrong
with Kubernetes itself. Alternatively, something inside or outside your cluster is overwhelming the API.

You can adjust this objective by modifying:
`api_latency_target` - How reliably you expect the Kubernetes API to respond to mutating API calls within 1s (1s is
hard coded in the Prometheus query)

## Memory Headroom

The ratio for this SLO (process_resident_memory_bytes / kube_node_status_allocatable) is arguably not strictly accurate,
but it is a useful ratio for pragmatic management of cluster memory. Workloads vary in their memory requirements and
patterns of memory usage. For example, some workloads need a lot of headroom because they sometimes burst in memory
usage. Other workloads "move around a lot" and require extra headroom to relocate pods during cluster maintenance or
(virtual) hardware changes. Still other workloads benefit from free memory outside of processes, for example because
their pattern of file io is assisted by having more memory available to cache files. The default thresholds in this
SLO are a starting point for a relatively memory-stable workload and "typical" management of memory overhead.

### Insufficient headroom

This objective is intended to burn budget when the cluster is "overly bin-packed" or has insufficient memory available
for either the nature of the workload, or how it behaves under maintenance or when the workload or cluster scales up
or down. If this objective exhausts its error budget, it's supposed to mean that the cluster is "too full" from a
memory resource perspective. You might need to scale it up faster, scale it down slower, or simply observe the workload
and adjust the setting to fence behavior that the workload owners deem appropriate for the cluster.

You can adjust this objective by modifying:
`memory_headroom_threshold` - How full is too full, from a memory resource perspective
`memory_headroom_target` - How reliably must this cluster avoid a headroom shortage

#### Memory underutilized

Similarly to insufficient headroom, we want to make sure that our clusters are not "wasting" memory that we are
paying for. If this objective exhausts its error budget, the cluster is oversized, from a memory resource perspective,
relative to what the workload is actually using. This might mean that the cluster is scaling up too fast, scaling down
too slow, or that the cluster is simply overallocated and can be downsized. It could also mean that the workload it is
supporting is not scaled on memory resources, but on some other resource such as CPU, network io, etc. This depends on
the nature of the workload and its memory usage.

You can adjust this objective by modifying:
`memory_utilization_threshold` - How much unallocated memory is acceptable for this cluster
`memory_utilization_target` - How much can this cluster tolerate periods of excess available memory

## Node Health

This SLO uses node-problem-detector and kube-state-metrics to measure a variety of issues that can affect cluster nodes.
Especially in a cloud or other virtualized environment, where hardware is often short lived and managed through
automation as fleets of resources, a degree of erroneous behavior is expected. This SLO gives you a way to put bounds on
that misbehavior, whether it is due to passing issues that self heal, or simply the realities of operating computing
resources at a large scale across zones and regions of a public or private cloud.

### Node problem detected

This burns budget as node-problem-detector reports problems on nodes in the cluster. This is a simple sum aggregation
across all node problem detector situations. At any sizable scale of cluster, you will see various things come up, such
as dud VMs/instances (various issues with underlying virtualization), network connectivity issues, things going wrong at
the OS level, etc. Adjust this to tolerate an acceptable level of such issues.

To adjust this objective, modify:
`node_problem_threshold` - How many problems in one sample are a problem for this cluster
`node_problem_target` - How strictly should this cluster be free of node problems

#### Node not ready

This uses kube-state-metrics to count how often a node is in a state other than Ready. This burns budget whenever nodes
are in some other state. You will see passing flurries of nodes not ready when doing some kinds of cluster maintenance
that add, remove, or restart nodes in the cluster, but there are also less predictable ways that nodes can go out of
Ready. This SLO allows you to set a goal for how often you want the nodes in your cluster to by cleanly Ready. Tune this
to a level that is tolerable for your cluster and workload.

To adjust this objective, modify:
`node_not_ready_threshold` - How many nodes you expect to be in states other than Ready under normal operation
`node_not_ready_target` - How reliably this cluster should be in operating normally

## Workload Health

One of the indrect advantages of using a hosting platform as rich as Kubernetes is that the cluster can "see" a lot of
detail about what is running within it. This gives us a way to monitor not just the cluster health but the health of
the things running inside it. There are limitations to what it can see, and so we strongly recommend setting SLOs on the
workloads themselves, by identifying the "one job" or top priorities of each service in a workload, and setting SLOs on
metrics that track those priorities. That said, monitoring how much workload is running in the cluster (or not able to
run due to some issue) gives cluster operators a way to spot issues. When pods are in various bad states, more than
what is normal in a given cluster, it could be that the workload owner has broken something, but it could also be that
the cluster operator has done something to break the workload, or that something external has changed that has broken
the workload. This SLO fences the normal operation of the workload to spot those situations.

### Not enough running

If this objective is burning budget, that means fewer pods are Running in the cluster than expected. This can occur
during application deployments, cluster maintenance, scaling, and many other situations. Tune this SLO so that it burns
some budget when these situations occur, but such that it doesn't exhaust the budget. Then, if it does exhaust the
budget or burn at too high a rate for too long you can tell that something is not as it should be with the workload.

To adjust this objective, modify:
`phase_running_threshold` - What proportion of the pods should be in Running phase during normal operation
`phase_running_target` - How reliably you want the workload to be in normal operation

#### Pods pending

If this objective is burning budget, there are more pods in Pending phase than expected. This means that workload is
trying to run and can't, due to misconfiguration, lack of resources, or a wide variety of other situations. Tune this to
burn some budget when application deployments are running or the cluster is under maintenance causing Pending phase
pods, but so that it doesn't exhaust its error budget under normal operation.

To adjust this objective, modify:
`phase_pending_threshold` - How many pods are expected to be in Pending phase normally
`phase_pending_target` - How reliably you need the cluster to be in a normal state with fewer Pending pods than that

#### Pods in bad state

If this objective is burning budget, there are more pods in Failed or Unknown phase than expected. Pods can be in
Unknown phase temporarily, but should not stay there for long. Failed phase pods have crashed in some way. Both of these
can occur in normal cluster operation, including during deploys of workload or cluster maintenance, but they should be
rare. Tune this so that it doesn't alert during normal operations but burns some budget when these situations occur.

To adjust this objective, modify:
`phase_failed_unknown_threshold` - How many pods are too many to be in a Failed or Unknown phase
`phase_failed_unknown_target` - How reliably you need the pods in this cluster to not be in Failed or Unknown phase

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_data_source"></a> [data\_source](#module\_data\_source) | ./data-source | n/a |
| <a name="module_n9agent"></a> [n9agent](#module\_n9agent) | ./n9agent | n/a |
| <a name="module_slos"></a> [slos](#module\_slos) | ./slos | n/a |

## Resources

| Name | Type |
|------|------|
| [nobl9_project.this](https://registry.terraform.io/providers/nobl9/nobl9/0.8.0/docs/resources/project) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amp_ws_endpoint"></a> [amp\_ws\_endpoint](#input\_amp\_ws\_endpoint) | Amazon Managed Prometheus endpoint | `string` | n/a | yes |
| <a name="input_api_error_rate_target"></a> [api\_error\_rate\_target](#input\_api\_error\_rate\_target) | SLO reliability target for apiserver error rate | `number` | n/a | yes |
| <a name="input_api_latency_target"></a> [api\_latency\_target](#input\_api\_latency\_target) | SLO reliability target for apiserver latency | `number` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Name of the Kubernetes cluster | `string` | n/a | yes |
| <a name="input_enable_kube_state_metrics_slos"></a> [enable\_kube\_state\_metrics\_slos](#input\_enable\_kube\_state\_metrics\_slos) | Would you like to include SLOs that rely on kube-state-metrics? | `bool` | n/a | yes |
| <a name="input_enable_kuberhealthy_slos"></a> [enable\_kuberhealthy\_slos](#input\_enable\_kuberhealthy\_slos) | Would you like to include SLOs that rely on kuberhealthy metrics? | `bool` | n/a | yes |
| <a name="input_enable_node_problem_detector_slos"></a> [enable\_node\_problem\_detector\_slos](#input\_enable\_node\_problem\_detector\_slos) | Would you like to include SLOs that rely on node-problem-detector? | `bool` | n/a | yes |
| <a name="input_kuberhealthy_pod_start_latency"></a> [kuberhealthy\_pod\_start\_latency](#input\_kuberhealthy\_pod\_start\_latency) | Allowable duration of kuberhealthy check | `number` | n/a | yes |
| <a name="input_kuberhealthy_pod_start_latency_target"></a> [kuberhealthy\_pod\_start\_latency\_target](#input\_kuberhealthy\_pod\_start\_latency\_target) | SLO reliability target for kuberhealthy pod start latency | `number` | n/a | yes |
| <a name="input_kuberhealthy_pod_start_success_target"></a> [kuberhealthy\_pod\_start\_success\_target](#input\_kuberhealthy\_pod\_start\_success\_target) | SLO reliability target for kuberhealthy pod start success | `number` | n/a | yes |
| <a name="input_memory_headroom_target"></a> [memory\_headroom\_target](#input\_memory\_headroom\_target) | SLO reliability target for memory headroom | `number` | n/a | yes |
| <a name="input_memory_headroom_threshold"></a> [memory\_headroom\_threshold](#input\_memory\_headroom\_threshold) | Maximum allowable memory consumption (fraction of 1.0) | `number` | n/a | yes |
| <a name="input_memory_utilization_target"></a> [memory\_utilization\_target](#input\_memory\_utilization\_target) | SLO reliability target for memory utilization | `number` | n/a | yes |
| <a name="input_memory_utilization_threshold"></a> [memory\_utilization\_threshold](#input\_memory\_utilization\_threshold) | Minimum allowable memory consumption (fraction of 1.0) | `number` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where electrodes will be installed | `string` | n/a | yes |
| <a name="input_nobl9_organization_id"></a> [nobl9\_organization\_id](#input\_nobl9\_organization\_id) | Nobl9 Organization ID (visible in Nobl9 web app under Settings > Account) | `string` | n/a | yes |
| <a name="input_node_not_ready_target"></a> [node\_not\_ready\_target](#input\_node\_not\_ready\_target) | SLO reliability target for node not ready | `number` | n/a | yes |
| <a name="input_node_not_ready_threshold"></a> [node\_not\_ready\_threshold](#input\_node\_not\_ready\_threshold) | Maximum allowable number of nodes in a non-ready state | `number` | n/a | yes |
| <a name="input_node_problem_target"></a> [node\_problem\_target](#input\_node\_problem\_target) | SLO reliability target for node problems | `number` | n/a | yes |
| <a name="input_node_problem_threshold"></a> [node\_problem\_threshold](#input\_node\_problem\_threshold) | Number of nodes problems that is considered a problem for the cluster | `number` | n/a | yes |
| <a name="input_phase_failed_unknown_target"></a> [phase\_failed\_unknown\_target](#input\_phase\_failed\_unknown\_target) | SLO reliability target for not having pods in a bad state (failed or unknown) | `number` | n/a | yes |
| <a name="input_phase_failed_unknown_threshold"></a> [phase\_failed\_unknown\_threshold](#input\_phase\_failed\_unknown\_threshold) | This many pods in a bad state (failed or unknown) is considered a failing workload | `number` | n/a | yes |
| <a name="input_phase_pending_target"></a> [phase\_pending\_target](#input\_phase\_pending\_target) | SLO reliability target for not having pods in a pending state | `number` | n/a | yes |
| <a name="input_phase_pending_threshold"></a> [phase\_pending\_threshold](#input\_phase\_pending\_threshold) | Maximum allowable number of pods in a pending state | `number` | n/a | yes |
| <a name="input_phase_running_target"></a> [phase\_running\_target](#input\_phase\_running\_target) | SLO reliability target for having enough things running in the cluster | `number` | n/a | yes |
| <a name="input_phase_running_threshold"></a> [phase\_running\_threshold](#input\_phase\_running\_threshold) | Minimum allowable ratio of pods that should be running | `number` | n/a | yes |
| <a name="input_rolling_window_days"></a> [rolling\_window\_days](#input\_rolling\_window\_days) | Evaluation time period for EKG SLOs | `number` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
