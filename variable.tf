###########################
# General Configuration
###########################
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

###########################
# KMS Key Configuration
###########################
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

variable "name" {
  description = "Name of alias. Setting `default = \"\"` makes this variable optional, allowing the module to be used without a specific alias name if none is provided by the user. If left empty, no alias is created by default, which can be useful when testing configurations or using dynamic naming."
  type        = string
  default     = ""
}

variable "deletion_window_in_days" {
  type    = number
  default = 7
}

variable "description" {
  type    = string
  default = "Example KMS key for encryption"
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

###########################
# Policy Configuration
###########################
variable "enable_default_policy" {
  type    = bool
  default = false
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
  default = {
    "custom-policy-statement-1" = {
      sid     = "CustomPolicyStatement"
      effect  = "Allow"
      actions = ["kms:Encrypt", "kms:Decrypt"]
      resources = ["*"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::509633460021:user/Nikita"]
        }
      ]
    }
  }
}

###########################
# Key Owners
###########################
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
  default = {
    "OwnerStatement" = {
      sid       = "AllowOwnerAllAccess"
      actions   = ["kms:*"]
      resources = ["*"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::509633460021:user/Nikita"]
        }
      ]
    }
  }
}

###########################
# Key Administrators
###########################
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
  default = {
    "AdminStatement" = {
      sid       = "AllowKeyAdmin"
      actions   = [
        "kms:Create*", "kms:Describe*", "kms:Enable*", "kms:List*", "kms:Put*",
        "kms:Update*", "kms:Revoke*", "kms:Disable*", "kms:Get*", "kms:Delete*",
        "kms:TagResource", "kms:UntagResource"
      ]
      resources = ["*"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::509633460021:user/KawalMehta"]
        }
      ]
    }
  }
}

###########################
# Key Users
###########################
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
  default = {
    "AppUsers" = {
      sid       = "AllowAppUse"
      actions   = ["kms:Encrypt", "kms:Decrypt"]
      resources = ["*"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::509633460021:user/aayush"]
        }
      ]
    }
  }
}

variable "key_service_users" {
  type    = map(any)
  default = {}
}

variable "key_symmetric_encryption_users" {
  type    = map(any)
  default = {}
}

variable "key_hmac_users" {
  type    = map(any)
  default = {}
}

variable "key_asymmetric_public_encryption_users" {
  type    = map(any)
  default = {}
}

variable "key_asymmetric_sign_verify_users" {
  type    = map(any)
  default = {}
}

###########################
# Replica Config
###########################
variable "primary_key_arn" {
  type    = string
  default = null
}

variable "primary_external_key_arn" {
  type    = string
  default = null
}

###########################
# Grants
###########################
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
  default = {
    "grant-app" = {
      name                 = "AppGrant"
      grantee_principal    = "arn:aws:iam::509633460021:user/aayush"
      operations           = ["Encrypt", "Decrypt"]
      constraints = {
        encryption_context_equals = {
          "App" = "MyApp"
        }
      }
      retiring_principal    = "arn:aws:iam::509633460021:user/Nikita"
      grant_creation_tokens = []
      retire_on_delete      = true
    }
  }
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