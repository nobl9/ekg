# [Nobl9 data source](https://docs.nobl9.com/Sources/)

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
| [nobl9_agent.this](https://registry.terraform.io/providers/nobl9/nobl9/0.8.0/docs/resources/agent) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amp_ws_endpoint"></a> [amp\_ws\_endpoint](#input\_amp\_ws\_endpoint) | Amazon Managed Prometheus endpoint | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Name of the Kubernetes cluster | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the Nobl9 project to put the data source in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | Nobl9 Client ID of the data source |
| <a name="output_client_secret"></a> [client\_secret](#output\_client\_secret) | Nobl9 Client Secret of the data source (NB: this is a secret - a password) |
| <a name="output_data_source_name"></a> [data\_source\_name](#output\_data\_source\_name) | Name (ID) of the agent data source in Nobl9 |
<!-- END_TF_DOCS -->
