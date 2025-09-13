output "arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = module.kms.arn
}

output "id" {
  description = "The globally unique identifier for the key"
  value       = module.kms.id
}

output "name" {
  description = "KMS Alias name"
  value       = module.kms.name
}

output "key_policy" {
  description = "The IAM resource policy set on the key"
  value       = module.kms.key_policy
}

output "external_key_expiration_model" {
  description = "Whether the key material expires. Empty when pending key material import, otherwise `KEY_MATERIAL_EXPIRES` or `KEY_MATERIAL_DOES_NOT_EXPIRE`"
  value       = module.kms.external_key_expiration_model
}

output "external_key_state" {
  description = "The state of the CMK"
  value       = module.kms.external_key_state
}

output "external_key_usage" {
  description = "The cryptographic operations for which you can use the CMK"
  value       = module.kms.external_key_usage
}

output "aliases" {
  description = "A map of aliases created and their attributes"
  value       = module.kms.aliases
}

output "grants" {
  description = "A map of grants created and their attributes"
  value       = module.kms.grants
  sensitive   = true
}

output "key_usage_name" {
  description = "Usage of key"
  value       = module.kms.key_usage_name
}
