# EKG (Essential Kubernetes Gauges)

Monitor the health of a Kubernetes cluster with ease, using Service Level Objectives (SLOs).

Essential Kubernetes Gauges (EKG) provides a set of standardized, prefabricated SLOs that measure
the reliability of a Kubernetes cluster. You can think of these SLOs as a check engine light that tells you
when your EKS cluster is misbehaving, with a historical record of when the cluster was behaving as desired and when not.
SLOs allow you to set adjustable goals for the reliability
aspects of your clusters. EKG includes SLOs that measure several aspects of a cluster:

- *Control Plane Health*
  - Is the Kubernetes API responding normally?
  - Is it performant?
- *Cluster Health*
  - Are the nodes healthy?
  - Is there some minimum of resource headroom?
  - Can we start new workloads?
- *Workload Health*
  - Is anything in a bad state?
  - Is there at least some kind of workload running?
- *Resource Efficiency*
  - Are resources underutilized in this cluster?
  - Is the cluster scaling in such as way that it is making good use of resources, without endangering workloads?
- *Cost Efficiency* measurements have been proposed as future enhancement and are under consideration.

These aspects of cluster behavior provide a gauge on how well Kubernetes (as an application) is running, as well as how
the overall cluster is faring, along with some insight into the health of the workloads the cluster is supporting. By
running EKG's SLOs, you can measure how well your clusters are doing over time, share numbers, charts, and reports on
cluster reliability across your teams, managers, and stakeholders, and use all the features of Nobl9, including alert policies and
alert integrations with a wide variety of popular tools.

For more information on the specific SLOs included in EKG and how to make use of them,
please see [the SLO docs](https://github.com/nobl9/ekg/blob/main/modules/nobl9/README.md)

## Supported Products

While EKG's SLOs and techniques are usable with any flavor of Kubernetes, and while the underlying instrumentation
frameworks are compatible with many distributions, we currently provide end-to-end automation for the following products:

- AWS EKS (Elastic Container Service for Kubernetes)

Support for additional Kubernetes distributions has been proposed and is under consideration.

## Architecture

![diagram](./diagram.png)

## Deployment of EKG with default settings on an existing EKS cluster

[Amazon Managed Service for Prometheus](https://aws.amazon.com/prometheus/)
is created (optionally), and metrics are collected from [electrodes](./modules/electrodes):

- [kube-state-metrics](modules/electrodes/kube-state-metrics/README.md) - metrics for the health of the various objects inside, such as
    deployments, nodes and pods
- [node-problem-detector](modules/electrodes/node-problem-detector/README.md) - metrics for the health of the node e.g. infrastructure daemon
    issues: ntp service down, hardware issues e.g. bad CPU, memory or disk, kernel issues e.g. kernel deadlock, corrupted file system, container
    runtime issues e.g. unresponsive runtime daemon
- [Kuberhealthy](modules/electrodes/kuberhealthy/README.md) - metrics for the health of the cluster, performs synthetic tests that ensures daemonsets,
    deployments can be deployed, DNS resolves names, etc.

Metrics are plumbed into Amazon Managed Service for Prometheus using
[AWS Distro for OpenTelemetry (ADOT)](https://aws-otel.github.io/). It collects metrics exposed by other services too,
thus it can be the only thing you need to collect all of the platform and application metrics from a cluster.

The repository gives fine-grain control over what can be deployed or reused. For instance, you can install only
chosen electrodes, or all of them, reuse existing Amazon Managed Service for Prometheus, or install only ADOT.
For details check the documentation of specific modules. Electrodes can be used with any Kubernetes cluster - EKS,
GKE, on-premise, etc.

To learn how to contribute please read the [contribution guidelines](./CONTRIBUTING.md).

## End-to-end installation of EKG on fresh EKS cluster

1. Prerequisites. You will need
    - A Nobl9 Organization. If you don't already have a Nobl9 org, you can sign up for Nobl9 free edition at https://app.nobl9.com/signup/
    - Terraform. If you need to install it: https://developer.hashicorp.com/terraform/downloads
    - An AWS account, with configuration and credentials connecting it to Terraform, for example by installing [AWS CLI](https://aws.amazon.com/cli/)
    - An EKS cluster. We assume you have a bunch of these, but if you want to spin up a fresh test cluster to try out EKG in isolation,
          how about following the steps in [this tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks)?
          The tutorial defaults to Terraform Cloud (which is quite nice) but for this exercise we recommend you click on the Terraform OSS
          tabs as you proceed.

2. Create a `terraform.tfvars` file. A staring point can be found in `terraform.tfvars.example`

    ```sh
    cp terraform.tfvars.example terraform.tfvars
    # edit that file with an editor of your choice
    # provide values for your AWS region, cluster name, and Nobl9 organization
    ```

3. Provide required secrets to the Nobl9 Terraform Provider. In the Nobl9 web UI, go to Settings > Access Keys, create an access key
  (save it somewhere) and then set the values as env vars:

    ```sh
    export TF_VAR_nobl9_client_id="<your Nobl9 Client ID>"
    export TF_VAR_nobl9_client_secret="<your Nobl9 Client Secret>"
    ```

4. Use Terraform to install the EKG components. In the root of this repository, run:

  ```sh
  terraform init
  ```

  ```sh
  terraform apply
  ```

Output of the above is

```sh
Apply complete! Resources: 36 added, 0 changed, 0 destroyed.

Outputs:

amp_ws_endpoint = "https://aps-workspaces.us-east-2.amazonaws.com/workspaces/ws-abcdef12-3456-7890-abcd-ef1234567890/"
```

Congratulations! EKG is up and running. Go back to the Nobl9 web UI and explore your newly created SLOs. For more
information about these SLOs, how to use them, and how to tune them to your clusters' conditions and workloads, see
[the SLO docs](https://github.com/nobl9/ekg/blob/main/modules/nobl9/README.md)

## What all does this install?

### Inside your EKS cluster

- kube-state-metrics

- kuberhealthy
- node-problem-detector
- Amazon Distro for OpenTelemetry (ADOT)
- A Nobl9 Agent compatible with and connecting to Amazon Managed Service for Prometheus

### Inside your Nobl9 Organization

- A Nobl9 Project and a Service to hold the SLOs

- The [EKG SLOs](https://github.com/nobl9/ekg/blob/main/modules/nobl9/README.md) (several prefab SLOs for Kubernetes)
- An agent-based Data Source configured to receive data from the Nobl9 Agent running in the EKS cluster

### Elsewhere inside your AWS Account

- An IAM User with access keys (configured in the Nobl9 Agent) and an inline policy allowing it to access the
  Amazon Managed Service for Prometheus workspace

- An Amazon Managed Service for Prometheus workspace, available at the URL output as `amp_ws_endpoint`

The `amp_ws_endpoint` is a URL for [Amazon Managed Service for Prometheus](https://aws.amazon.com/prometheus/) that can be
directly used for instance in [Grafana](https://grafana.com/) or [Nobl9](https://www.nobl9.com/). Deploying Grafana or
other visualization tools is not in the scope of this project, but if you are looking for a quick and clean Grafana to
play with as you explore the metrics in your newly created Prometheus, how about [running it locally from a docker image](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/)
and include the additional env vars required to [allow it to connect to Amazon's managed prom](https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-onboard-query-standalone-grafana.html).

Or in short:

``` sh
docker run -d -p 3000:3000 --name="grafana" -e "AWS_SDK_LOAD_CONFIG=true" -e "GF_AUTH_SIGV4_AUTH_ENABLED=true" grafana/grafana-oss
```

Then when you configure a Prometheus data source it will offer AWS specific settings to connect it to that `amp_ws_endpoint`

## Helpful Links

- [Nobl9 Documentation](https://docs.nobl9.com/)
- [Nobl9 SLOcademy](https://docs.nobl9.com/slocademy), a starting point to explore SLOs and Nobl9's feature set
- [SLOconf](https://www.sloconf.com/), a conference dedicated to SLOs, rich with online content about SLOs from across
the industry

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |
| <a name="requirement_nobl9"></a> [nobl9](#requirement\_nobl9) | 0.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.56.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.18.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_adot_amp"></a> [adot\_amp](#module\_adot\_amp) | ./modules/adot-amp | n/a |
| <a name="module_electrodes"></a> [electrodes](#module\_electrodes) | ./modules/electrodes | n/a |
| <a name="module_nobl9"></a> [nobl9](#module\_nobl9) | ./modules/nobl9 | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_error_rate_target"></a> [api\_error\_rate\_target](#input\_api\_error\_rate\_target) | SLO reliability target for apiserver error rate | `number` | n/a | yes |
| <a name="input_api_latency_target"></a> [api\_latency\_target](#input\_api\_latency\_target) | SLO reliability target for apiserver latency | `number` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Namespace speciefed by variable namespace will be created, if not exists | `bool` | `true` | no |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_kube_state_metrics_slos"></a> [enable\_kube\_state\_metrics\_slos](#input\_enable\_kube\_state\_metrics\_slos) | Would you like to include SLOs that rely on kube-state-metrics? | `bool` | n/a | yes |
| <a name="input_enable_kuberhealthy_slos"></a> [enable\_kuberhealthy\_slos](#input\_enable\_kuberhealthy\_slos) | Would you like to include SLOs that rely on kuberhealthy metrics? | `bool` | n/a | yes |
| <a name="input_enable_node_problem_detector_slos"></a> [enable\_node\_problem\_detector\_slos](#input\_enable\_node\_problem\_detector\_slos) | Would you like to include SLOs that rely on node-problem-detector? | `bool` | n/a | yes |
| <a name="input_kuberhealthy_pod_start_latency"></a> [kuberhealthy\_pod\_start\_latency](#input\_kuberhealthy\_pod\_start\_latency) | Allowable duration of kuberhealthy check | `number` | n/a | yes |
| <a name="input_kuberhealthy_pod_start_latency_target"></a> [kuberhealthy\_pod\_start\_latency\_target](#input\_kuberhealthy\_pod\_start\_latency\_target) | SLO reliability target for kuberhealthy pod start latency | `number` | n/a | yes |
| <a name="input_kuberhealthy_pod_start_success_target"></a> [kuberhealthy\_pod\_start\_success\_target](#input\_kuberhealthy\_pod\_start\_success\_target) | SLO reliability target for kuberhealthy pod start success | `number` | n/a | yes |
| <a name="input_managed_prometheus_workspace_id"></a> [managed\_prometheus\_workspace\_id](#input\_managed\_prometheus\_workspace\_id) | Amazon Managed Service for Prometheus Workspace IDAmazon Managed Service for Prometheus Workspace ID (when nothing passed new will be created) | `string` | `""` | no |
| <a name="input_memory_headroom_target"></a> [memory\_headroom\_target](#input\_memory\_headroom\_target) | SLO reliability target for memory headroom | `number` | n/a | yes |
| <a name="input_memory_headroom_threshold"></a> [memory\_headroom\_threshold](#input\_memory\_headroom\_threshold) | Maximum allowable memory consumption (fraction of 1.0) | `number` | n/a | yes |
| <a name="input_memory_utilization_target"></a> [memory\_utilization\_target](#input\_memory\_utilization\_target) | SLO reliability target for memory utilization | `number` | n/a | yes |
| <a name="input_memory_utilization_threshold"></a> [memory\_utilization\_threshold](#input\_memory\_utilization\_threshold) | Minimum allowable memory consumption (fraction of 1.0) | `number` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where electrodes will be installed | `string` | `"ekg-monitoring"` | no |
| <a name="input_nobl9_client_id"></a> [nobl9\_client\_id](#input\_nobl9\_client\_id) | Nobl9 Client ID (create in Nobl9 web app using Settings > Access Keys) | `string` | n/a | yes |
| <a name="input_nobl9_client_secret"></a> [nobl9\_client\_secret](#input\_nobl9\_client\_secret) | Nobl9 Client Secret (create in Nobl9 web app using Settings > Access Keys) | `string` | n/a | yes |
| <a name="input_nobl9_organization_id"></a> [nobl9\_organization\_id](#input\_nobl9\_organization\_id) | Nobl9 Organization ID (visible in Nobl9 web app under Settings > Account) | `string` | n/a | yes |
| <a name="input_nobl9_project_name"></a> [nobl9\_project\_name](#input\_nobl9\_project\_name) | Nobl9 Project name (create one in the Nobl9 web app using Catalog > Projects, or use 'default') | `string` | `"default"` | no |
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
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_amp_ws_endpoint"></a> [amp\_ws\_endpoint](#output\_amp\_ws\_endpoint) | Amazon Managed Prometheus endpoint |
<!-- END_TF_DOCS -->
