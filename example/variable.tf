variable "create_kms" {
  type    = bool
  default = true
}

variable "create_external" {
  type    = bool
  default = false
}

variable "create_replica" {
  type    = bool
  default = false
}

variable "create_replica_external" {
  type    = bool
  default = false
}

variable "name" {
  type    = string
  default = ""
}


# KMS Key
variable "bypass_policy_lockout_safety_check" {
  type    = bool
  default = false
}
variable "customer_master_key_spec" {
  type    = string
  default = "SYMMETRIC_DEFAULT"
}
variable "custom_key_store_id" {
  type    = string
  default = null
}
variable "deletion_window_in_days" {
  type    = number
  default = 7
}
variable "description" {
  type    = string
  default = "aws kms key for encryption"
}
variable "enable_key_rotation" {
  type    = bool
  default = true
}
variable "is_enabled" {
  type    = bool
  default = true
}
variable "key_material_base64" {
  type    = string
  default = ""
}
variable "key_usage" {
  type    = string
  default = "ENCRYPT_DECRYPT"
}
variable "multi_region" {
  type    = bool
  default = false
}
variable "rotation_period_in_days" {
  type    = number
  default = 365
}
variable "valid_to" {
  type    = string
  default = null
}

# Policy
variable "enable_default_policy" {
  type    = bool
  default = true
}
variable "principal_type" {
  type    = string
  default = "AWS"
}
variable "source_policy_documents" {
  type    = list(string)
  default = []
}
variable "override_policy_documents" {
  type    = list(string)
  default = []
}
variable "policy" {
  type = map(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  }))
  default = {}
}
variable "key_owners" {
  type = map(object({
    sid       = string
    actions   = list(string)
    resources = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  }))
  default = {}
}
variable "key_administrators" {
  type = map(object({
    sid       = string
    actions   = list(string)
    resources = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  }))
  default = {}
}
variable "key_users" {
  type = map(object({
    sid       = string
    actions   = list(string)
    resources = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  }))
  default = {}
}
variable "key_service_users" {
  type = map(object({
    sid       = string
    actions   = list(string)
    resources = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  }))
  default = {}
}
variable "key_symmetric_encryption_users" {
  type = map(object({
    sid       = string
    actions   = list(string)
    resources = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  }))
  default = {}
}
variable "key_hmac_users" {
  type = map(object({
    sid       = string
    actions   = list(string)
    resources = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  }))
  default = {}
}
variable "key_asymmetric_public_encryption_users" {
  type = map(object({
    sid       = string
    actions   = list(string)
    resources = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  }))
  default = {}
}
variable "key_asymmetric_sign_verify_users" {
  type = map(object({
    sid       = string
    actions   = list(string)
    resources = list(string)
    principals = list(object({
      type        = string
      identifiers = list(string)
    }))
  }))
  default = {}
}

# Replica Keys
variable "primary_key_arn" {
  type    = string
  default = null
}

variable "primary_external_key_arn" {
  type    = string
  default = null
}

# Grants
variable "grants" {
  type = map(object({
    name              = string
    grantee_principal = string
    operations        = list(string)
    constraints = object({
      encryption_context_equals = map(string)
    })
    retiring_principal    = string
    grant_creation_tokens = list(string)
    retire_on_delete      = bool
  }))
  default = {}
}




variable "env" {
  type = string
  default = "dev"
  
}

variable "owner" {
  type = string
  default = "opstree"
}

variable "app" {
  type = string
  default = "otcloud-kit"
  
}

variable "region" {
  type = string
  default = "us-east-1"
  
}