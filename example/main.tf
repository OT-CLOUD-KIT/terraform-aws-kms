module "standard_tags" {
  source = "git@github.com:OT-CLOUD-KIT/terraform-aws-standard-tagging.git?ref=dev"

  bu      = var.bu
  program = var.program
  app     = var.app
  team    = var.team
  region  = var.region
  env     = var.env
}

module "naming" {
  source   = "git@github.com:OT-CLOUD-KIT/terraform-aws-naming.git?ref=dev"
  bu       = var.bu
  env      = var.env
  app      = var.app
  resource = var.resource
}



module "kms" {
  source = "git@github.com:OT-CLOUD-KIT/terraform-aws-kms.git?ref=Feature"

  # General
  create_kms       = var.create_kms
  create_external  = var.create_external
  create_replica   = var.create_replica
  create_replica_external = var.create_replica_external
  name       = module.naming.naming_tag[0]

  bu      = var.bu
  program = var.program
  app     = var.app
  env     = var.env
  team    = var.team
  region  = var.region

  # KMS key config
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  customer_master_key_spec           = var.customer_master_key_spec
  custom_key_store_id                = var.custom_key_store_id
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = var.description
  enable_key_rotation                = var.enable_key_rotation
  is_enabled                         = var.is_enabled
  key_material_base64                = var.key_material_base64
  key_usage                          = var.key_usage
  multi_region                       = var.multi_region
  rotation_period_in_days            = var.rotation_period_in_days
  valid_to                           = var.valid_to

  # Policy
  enable_default_policy        = var.enable_default_policy
  principal_type               = var.principal_type
  source_policy_documents      = var.source_policy_documents
  override_policy_documents    = var.override_policy_documents
  policy                       = var.policy
  key_owners                   = var.key_owners
  key_administrators           = var.key_administrators
  key_users                    = var.key_users
  key_service_users            = var.key_service_users
  key_symmetric_encryption_users = var.key_symmetric_encryption_users
  key_hmac_users               = var.key_hmac_users
  key_asymmetric_public_encryption_users = var.key_asymmetric_public_encryption_users
  key_asymmetric_sign_verify_users       = var.key_asymmetric_sign_verify_users

  # Replica settings
  primary_key_arn          = var.primary_key_arn
  primary_external_key_arn = var.primary_external_key_arn

  # Grants
  grants = var.grants
}
