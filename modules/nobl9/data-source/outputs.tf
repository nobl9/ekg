output "client_id" {
  value       = nobl9_agent.this.client_id
  description = "Nobl9 Client ID of the data source"
}

output "client_secret" {
  value       = nobl9_agent.this.client_secret
  description = "Nobl9 Client Secret of the data source (NB: this is a secret -- a password)"
}

output "data_source_name" {
  value       = nobl9_agent.this.name
  description = "Name (ID) of the agent data source in Nobl9"
}
