data "aws_partition" "current" {
  count = var.create_kms ? 1 : 0
}
data "aws_caller_identity" "current" {
  count = var.create_kms ? 1 : 0
}

locals {
  account_id = try(data.aws_caller_identity.current[0].account_id, "")
  partition  = try(data.aws_partition.current[0].partition, "")
}

#-------------------------------------------------------------------------------
# Key
#-------------------------------------------------------------------------------
resource "aws_kms_key" "this" {
  count = var.create_kms && !var.create_external && !var.create_replica && !var.create_replica_external ? 1 : 0

  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  customer_master_key_spec           = var.customer_master_key_spec
  custom_key_store_id                = var.custom_key_store_id
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = var.description
  enable_key_rotation                = var.enable_key_rotation
  is_enabled                         = var.is_enabled
  key_usage                          = var.key_usage
  multi_region                       = var.multi_region
  policy                             = data.aws_iam_policy_document.this[0].json
  rotation_period_in_days            = var.rotation_period_in_days

  tags = var.tags

}

#-------------------------------------------------------------------------------
# External Key
#-------------------------------------------------------------------------------
resource "aws_kms_external_key" "this" {
  count = var.create_kms && var.create_external && !var.create_replica && !var.create_replica_external ? 1 : 0

  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = var.description
  enabled                            = var.is_enabled
  key_material_base64                = var.key_material_base64
  multi_region                       = var.multi_region
  policy                             = data.aws_iam_policy_document.this[0].json
  valid_to                           = var.valid_to

  tags = var.tags
}

#-------------------------------------------------------------------------------
# Replica Key
#-------------------------------------------------------------------------------
resource "aws_kms_replica_key" "this" {
  count = var.create_kms && var.create_replica && !var.create_external && !var.create_replica_external ? 1 : 0

  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = var.description
  primary_key_arn                    = var.primary_key_arn
  enabled                            = var.is_enabled
  policy                             = data.aws_iam_policy_document.this[0].json

  tags = var.tags
}

#-------------------------------------------------------------------------------
# Replica External Key
#-------------------------------------------------------------------------------
resource "aws_kms_replica_external_key" "this" {
  count = var.create_kms && !var.create_replica && !var.create_external && var.create_replica_external ? 1 : 0

  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = var.description
  enabled                            = var.is_enabled
  key_material_base64                = var.key_material_base64
  policy                             = data.aws_iam_policy_document.this[0].json
  primary_key_arn                    = var.primary_external_key_arn
  valid_to                           = var.valid_to

  tags = var.tags

}

#-------------------------------------------------------------------------------
# Policy
#-------------------------------------------------------------------------------
data "aws_iam_policy_document" "this" {
  count = var.create_kms ? 1 : 0

  source_policy_documents   = var.source_policy_documents
  override_policy_documents = var.override_policy_documents

  dynamic "statement" {
    for_each = var.enable_default_policy ? [1] : []

    content {
      sid       = "Default"
      actions   = ["kms:*"]
      resources = ["*"]

      principals {
        type        = var.principal_type
        identifiers = ["arn:${local.partition}:iam::${local.account_id}:root"]
      }
    }
  }

  #-------------------------------------------------------------------------------
  # Key owner - all key operations
  #-------------------------------------------------------------------------------
  dynamic "statement" {
    for_each = var.key_owners

    content {
      sid       = statement.value.sid
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }

  #-------------------------------------------------------------------------------------------------------------------------------------------
  # Key administrators - https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-administrators
  # Example IAM policy statements for key administrators
  #-------------------------------------------------------------------------------------------------------------------------------------------
  dynamic "statement" {
    for_each = var.key_administrators

    content {
      sid       = statement.value.sid
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }

  #--------------------------------------------------------------------------------------------------------------------------
  # Key users - https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-users
  #--------------------------------------------------------------------------------------------------------------------------
  dynamic "statement" {
    for_each = var.key_users

    content {
      sid       = statement.value.sid
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }

  #----------------------------------------------------------------------------------------------------------------------------------
  # Key service users - https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration
  #----------------------------------------------------------------------------------------------------------------------------------
  dynamic "statement" {
    for_each = var.key_service_users

    content {
      sid       = statement.value.sid
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      condition {
        test     = "Bool"
        variable = "kms:GrantIsForAWSResource"
        values   = [true]
      }
    }
  }

  #-------------------------------------------------------------------------------------------------------------------------------------
  # Key cryptographic operations - https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-users-crypto
  # IAM policy statements for key symmetric encryption users
  #-------------------------------------------------------------------------------------------------------------------------------------
  dynamic "statement" {
    for_each = var.key_symmetric_encryption_users

    content {
      sid       = statement.value.sid
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }

  #-------------------------------------------------------------------------------
  # IAM policy statements for key HMAC users
  #-------------------------------------------------------------------------------
  dynamic "statement" {
    for_each = var.key_hmac_users

    content {
      sid       = statement.value.sid
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }

  #-------------------------------------------------------------------------------
  # IAM policy statements for key asymmetric public encryption users
  #-------------------------------------------------------------------------------
  dynamic "statement" {
    for_each = var.key_asymmetric_public_encryption_users

    content {
      sid       = statement.value.sid
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }

  #-------------------------------------------------------------------------------
  # IAM policy statements for key asymmetric sign and verify users
  #-------------------------------------------------------------------------------
  dynamic "statement" {
    for_each = var.key_asymmetric_sign_verify_users

    content {
      sid       = statement.value.sid
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }

  dynamic "statement" {
    for_each = var.policy

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }
}

#-------------------------------------------------------------------------------
# Alias
#-------------------------------------------------------------------------------
resource "aws_kms_alias" "this" {
  name          = "alias/${var.name}"
  target_key_id = try(aws_kms_key.this[0].key_id, aws_kms_external_key.this[0].id, aws_kms_replica_key.this[0].key_id, aws_kms_replica_external_key.this[0].key_id)
}

#-------------------------------------------------------------------------------
# Grant
#-------------------------------------------------------------------------------
resource "aws_kms_grant" "this" {
  for_each = { for k, v in var.grants : k => v if var.create_kms }

  name              = try(each.value.name, each.key)
  key_id            = try(aws_kms_key.this[0].key_id, aws_kms_external_key.this[0].id, aws_kms_replica_key.this[0].key_id, aws_kms_replica_external_key.this[0].key_id)
  grantee_principal = each.value.grantee_principal
  operations        = each.value.operations

  dynamic "constraints" {
    for_each = length(lookup(each.value, "constraints", {})) == 0 ? [] : [each.value.constraints]

    content {
      encryption_context_equals = try(constraints.value.encryption_context_equals, null)
      encryption_context_subset = try(constraints.value.encryption_context_subset, null)
    }
  }

  retiring_principal    = try(each.value.retiring_principal, null)
  grant_creation_tokens = try(each.value.grant_creation_tokens, null)
  retire_on_delete      = try(each.value.retire_on_delete, null)
}
