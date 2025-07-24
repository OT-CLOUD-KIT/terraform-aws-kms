#-------------------------------------------------------------------------------
# Data Sources
#-------------------------------------------------------------------------------
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
# Policy Document
#-------------------------------------------------------------------------------
data "aws_iam_policy_document" "kms_policy" {
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
# KMS Key
#-------------------------------------------------------------------------------
resource "aws_kms_key" "primary_key" {
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
  policy                             = data.aws_iam_policy_document.kms_policy[0].json
  rotation_period_in_days            = var.rotation_period_in_days

  tags = merge(
    { Name = "${local.base_name}-kms-key" },
    local.common_tags
  )
}

#-------------------------------------------------------------------------------
# External Key
#-------------------------------------------------------------------------------
resource "aws_kms_external_key" "external_primary_key" {
  count = var.create_kms && var.create_external && !var.create_replica && !var.create_replica_external ? 1 : 0

  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = var.description
  enabled                            = var.is_enabled
  key_material_base64                = var.key_material_base64
  multi_region                       = var.multi_region
  policy                             = data.aws_iam_policy_document.kms_policy[0].json
  valid_to                           = var.valid_to

  tags = merge(
    { Name = "${local.base_name}-kms-external-key" },
    local.common_tags
  )
}

#-------------------------------------------------------------------------------
# Replica Key
#-------------------------------------------------------------------------------
resource "aws_kms_replica_key" "replica_key" {
  count = var.create_kms && var.create_replica && !var.create_external && !var.create_replica_external ? 1 : 0

  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = var.description
  primary_key_arn                    = var.primary_key_arn
  enabled                            = var.is_enabled
  policy                             = data.aws_iam_policy_document.kms_policy[0].json

  tags = merge(
    { Name = "${local.base_name}-kms-replica-key" },
    local.common_tags
  )
}

#-------------------------------------------------------------------------------
# Replica External Key
#-------------------------------------------------------------------------------
resource "aws_kms_replica_external_key" "external_replica_key" {
  count = var.create_kms && !var.create_replica && !var.create_external && var.create_replica_external ? 1 : 0

  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = var.description
  enabled                            = var.is_enabled
  key_material_base64                = var.key_material_base64
  primary_key_arn                    = var.primary_external_key_arn
  valid_to                           = var.valid_to
  policy                             = data.aws_iam_policy_document.kms_policy[0].json

  tags = merge(
    { Name = "${local.base_name}-kms-replica-external-key" },
    local.common_tags
  )
}

#-------------------------------------------------------------------------------
# Alias
#-------------------------------------------------------------------------------
resource "aws_kms_alias" "key_alias" {
  name = "alias/${var.name}"
  target_key_id = try(
    aws_kms_key.primary_key[0].key_id,
    aws_kms_external_key.external_primary_key[0].id,
    aws_kms_replica_key.replica_key[0].key_id,
    aws_kms_replica_external_key.external_replica_key[0].key_id
  )
}

#-------------------------------------------------------------------------------
# Grant
#-------------------------------------------------------------------------------
resource "aws_kms_grant" "custom_grant" {
  for_each = { for k, v in var.grants : k => v if var.create_kms }

  name              = try(each.value.name, each.key)
  key_id            = try(
    aws_kms_key.primary_key[0].key_id,
    aws_kms_external_key.external_primary_key[0].id,
    aws_kms_replica_key.replica_key[0].key_id,
    aws_kms_replica_external_key.external_replica_key[0].key_id
  )
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
