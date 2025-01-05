# ------------------------------------------------------------
# naming conventions and tags variables
# ------------------------------------------------------------
variable "env" {
  description = "name of the environment"
  type        = string
}

variable "bu" {
  description = "name of the business unit"
  type        = string
}

variable "app" {
  description = "Name of the application, For ex: network, shared, ot etc."
  type        = string
}

variable "tenant" {
  description = "Name of the tenant"
  type        = string
  default     = ""
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

variable "create_kms" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

#-------------------------------------------------------------------------------
# Key
#-------------------------------------------------------------------------------
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
