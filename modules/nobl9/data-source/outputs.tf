output "client_id" {
  description = "Nobl9 Client ID of the data source"
  value       = nobl9_agent.this.client_id
}

output "client_secret" {
  description = "Nobl9 Client Secret of the data source (NB: this is a secret - a password)"
  value       = nobl9_agent.this.client_secret
}

output "data_source_name" {
  description = "Name (ID) of the agent data source in Nobl9"
  value       = nobl9_agent.this.name
}
