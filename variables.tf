variable "create_kms" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "name" {
  description = "Name of alias. Setting `default = \"\"` makes this variable optional, allowing the module to be used without a specific alias name if none is provided by the user. If left empty, no alias is created by default, which can be useful when testing configurations or using dynamic naming."
  type        = string
  default     = ""
}

#-------------------------------------------------------------------------------
# Key
#-------------------------------------------------------------------------------
variable "create_external" {
  description = "Determines whether an external CMK (externally provided material) will be created or a standard CMK (AWS provided material)"
  type        = bool
  default     = false
}

variable "bypass_policy_lockout_safety_check" {
  description = "A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable"
  type        = bool
  default     = false
}

variable "customer_master_key_spec" {
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_256`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, or `ECC_SECG_P256K1`. Defaults to `SYMMETRIC_DEFAULT`"
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "custom_key_store_id" {
  description = "ID of the KMS Custom Key Store where the key will be stored instead of KMS (e.g., CloudHSM). This variable is optional. If left unset (i.e., default = null), the standard KMS key store will be used."
  type        = string
  default     = null
}

variable "deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between `7` and `30`, inclusive. If you do not specify a value, it defaults to `30`"
  type        = number
  default     = "7"
}

variable "description" {
  description = "The description of the key as viewed in AWS console"
  type        = string
  default     = "aws kms key for encryption"
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled. Defaults to `true`"
  type        = bool
  default     = true
}

variable "is_enabled" {
  description = "Specifies whether the key is enabled. Defaults to `true`"
  type        = bool
  default     = true
}

variable "key_material_base64" {
  description = "Base64 encoded 256-bit symmetric encryption key material to import. The CMK is permanently associated with this key material. This is for external key use only. If left empty (default = \"\"), AWS KMS will generate a new key material."
  type        = string
  default     = ""
}

variable "key_usage" {
  description = "Specifies the intended use of the key. Valid values: `ENCRYPT_DECRYPT` or `SIGN_VERIFY`. Defaults to `ENCRYPT_DECRYPT`"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "multi_region" {
  description = "Indicates whether the KMS key is a multi-Region (`true`) or regional (`false`) key. Defaults to `false`"
  type        = bool
  default     = false
}

variable "policy" {
  description = "Map containing IAM policy statements. If not specified, defaults to an empty map, meaning no policies are applied."
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

variable "valid_to" {
  description = "Time at which the imported key material expires. If not specified (default = null), the key material does not expire, and the CMK remains usable indefinitely."
  type        = string
  default     = null
}

variable "enable_default_policy" {
  description = "Specifies whether to enable the default key policy. Defaults to `true`"
  type        = bool
  default     = true
}

#-------------------------------------------------------------------------------
# Specifies the type of principal for IAM policies.
# By default, set to "AWS" for AWS services or resources.
#-------------------------------------------------------------------------------
variable "principal_type" {
  type    = string
  default = "AWS"
}

#-------------------------------------------------------------------------------
# Variables for defining IAM policy statement for key owners
#-------------------------------------------------------------------------------
variable "key_owners" {
  description = "A map of key owners with their respective properties, The default = {} means no key owners are defined by default so must explicitly define key owners in terraform configuration if needed."
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

#-------------------------------------------------------------------------------
# Variables for defining IAM policy statement for Key administrators
#-------------------------------------------------------------------------------
variable "key_administrators" {
  description = "A map of key administrators with their respective properties, The default = {} means no Key administrators are defined by default so must explicitly define Key administrators in terraform configuration if needed."
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

#-------------------------------------------------------------------------------
# Variables for defining IAM policy statement for Key users
#-------------------------------------------------------------------------------
variable "key_users" {
  description = "A map of IAM ARNs for key users with their respective properties, The default = {} means no Key users are defined by default so must explicitly define Key users in terraform configuration if needed."
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

#-------------------------------------------------------------------------------
# Variables for defining IAM policy statement for Key service users
#-------------------------------------------------------------------------------
variable "key_service_users" {
  description = "A map of IAM ARNs for key service users with their respective properties, The default = {} means no Key service users are defined by default so must explicitly define Key service users in terraform configuration if needed."
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

#-------------------------------------------------------------------------------
# Variables for defining IAM policy statement for KeySymmetricEncryption users
#-------------------------------------------------------------------------------
variable "key_symmetric_encryption_users" {
  description = "A map of IAM ARNs for key symmetric encryption users with their respective properties, The default = {} means no key symmetric encryption users are defined by default so must explicitly define key symmetric encryption users in terraform configuration if needed"
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
  description = "A map of IAM ARNs for key HMAC users with their respective properties, The default = {} means no key hmac users are defined by default so must explicitly define key hmac users in terraform configuration if needed"
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
  description = "A map of IAM ARNs for key asymmetric public encryption users with their respective properties, The default = {} means no key asymmetric public encryption users are defined by default so must explicitly define key asymmetric public encryption users in terraform configuration if needed"
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
  description = "A map of IAM ARNs for key asymmetric sign and verify users with their respective properties, The default = {} means no key asymmetric sign verify users are defined by default so must explicitly define key asymmetric sign verify users in terraform configuration if needed"
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

variable "source_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s. The default value of `[]` means no policy documents are provided by default. If no documents are required, users can leave this list empty, but they can define custom policy documents in terraform configuration as needed."
  type        = list(string)
  default     = []
}

variable "override_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid`"
  type        = list(string)
  default     = []
}

variable "rotation_period_in_days" {
  description = "Custom period of time between each rotation date. Must be a number between 90 and 2560 (inclusive)"
  type        = number
  default     = "365"
}

#-------------------------------------------------------------------------------
# Replica Key
#-------------------------------------------------------------------------------
variable "create_replica" {
  description = "Determines whether a replica standard CMK will be created (AWS provided material)"
  type        = bool
  default     = false
}

variable "primary_key_arn" {
  description = "The primary key arn of a multi-region replica key, Setting `default = null` makes this variable optional if left null, no primary key ARN is specified, and the configuration assumes a single-region setup. users should define this only when creating a multi-region key setup."
  type        = string
  default     = null
}

#-------------------------------------------------------------------------------
# Replica External Key
#-------------------------------------------------------------------------------
variable "create_replica_external" {
  description = "Determines whether a replica external CMK will be created (externally provided material)"
  type        = bool
  default     = false
}

variable "primary_external_key_arn" {
  description = "The primary external key arn of a multi-region replica external key, Setting `default = null` makes this variable optional, allowing configurations to proceed without specifying an ARN if a primary external key is not in use. If left null, no external primary key will be associated; define this only when creating a multi-region replica with an external key."
  type        = string
  default     = null
}

#-------------------------------------------------------------------------------
# Grant
#-------------------------------------------------------------------------------
variable "grants" {
  description = "A map of grant definitions to create, The `default = {}` indicates that, by default, no grants are set up, allowing users to specify grants only if they are needed."
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
