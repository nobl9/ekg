# [Nobl9 Agent](https://docs.nobl9.com/Nobl9_Agent)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.4.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.nobl9-ekg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.nobl9-ekg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.nobl9-ekg-ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [helm_release.n9agent](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.example](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [aws_iam_policy_document.nobl9-ekg-ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_client_id"></a> [agent\_client\_id](#input\_agent\_client\_id) | Client ID of the data source agent (from Nobl9 UI: Integrations > Sources > [your data source] > Agent Configuration) | `string` | n/a | yes |
| <a name="input_agent_client_secret"></a> [agent\_client\_secret](#input\_agent\_client\_secret) | Client Secret of the data source agent (from Nobl9 UI: Integrations > Sources > [your data source] > Agent Configuration) | `string` | n/a | yes |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of Helm Chart | `string` | `"1.0.4"` | no |
| <a name="input_data_source_name"></a> [data\_source\_name](#input\_data\_source\_name) | Name (ID) of the agent data source in Nobl9 | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace where Helm Chart will be installed | `string` | n/a | yes |
| <a name="input_nobl9_organization_id"></a> [nobl9\_organization\_id](#input\_nobl9\_organization\_id) | Nobl9 Organization ID (visible in Nobl9 web app under Settings > Account) | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the Nobl9 project to put these SLOs in | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
