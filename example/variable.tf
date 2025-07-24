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
  description = "Environment short name. Must be one of: d (dev), p (prod), q (qa), s (stage), g (global)."
  type        = string
  default     = "d"
  validation {
    condition     = contains(["d", "p", "q", "s", "g"], var.env)
    error_message = "env must be one of 'd', 'p', 'q', 's', 'g'."
  }
}

variable "bu" {
  description = "Business unit name (e.g., pcs, ultrasound). Max 5 characters."
  type        = string
  default     = "ot"
  validation {
    condition     = length(var.bu) <= 5
    error_message = "The business unit name must be less than or equal to 5 characters."
  }
}

variable "app" {
  description = "Application name (e.g., network, shared). Max 6 characters."
  type        = string
  default     = "bp"
  validation {
    condition     = length(var.app) <= 6
    error_message = "The app name must be less than or equal to 6 characters."
  }
}

variable "resource" {
  description = "Resource name (e.g., eks, efs, ecr). Max 15 characters."
  type        = string
  default     = "instance"
  validation {
    condition     = length(var.resource) <= 15
    error_message = "The resource name must be less than or equal to 15 characters."
  }
}

variable "tenant" {
  description = "Tenant name (e.g., app1, app2). Max 6 characters."
  type        = string
  default     = ""
  validation {
    condition     = length(var.tenant) <= 6
    error_message = "The tenant name must be less than or equal to 6 characters."
  }
}

variable "enabled_features" {
  type    = list(string)
  default = []
}

variable "random_alphanumeric_len" {
  description = "The length of random alphanumeric string desired. Min: 1, Max: 4."
  type        = number
  default     = 4
  validation {
    condition     = var.random_alphanumeric_len >= 1 && var.random_alphanumeric_len <= 4
    error_message = "The length must be between 1 and 4."
  }
}

variable "special" {
  description = "Include special characters like !@#$%&*()-_=+[]{}<>:? in the generated name."
  type        = bool
  default     = false
}

variable "upper" {
  description = "Include uppercase characters in the generated name."
  type        = bool
  default     = false
}

variable "number" {
  description = "Include numbers in the generated name."
  type        = bool
  default     = true
}

variable "gen_no_of_names" {
  description = "Number of names to generate."
  type        = number
  default     = 1
}

variable "team" {
  description = "The email address of the team who owns the application, ex:digitalops@gehealthcare.com"
  type        = string
  default     = "infra"
}

variable "program" {
  description = "Name of the Program, For ex: OT, BP etc."
  type        = string
  default     = "ot"
}

variable "region" {
  type    = string
  default = "us-east-1"
}
