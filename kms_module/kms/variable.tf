variable "alias_name" {
  description = "The name of the key alias"
  type        = string
}

variable "deletion_window_in_days" {
  description = "The duration in days after which the key is deleted after destruction of the resource"
  type        = string
  default     = 30
}

variable "is_enabled" {
  description = "Status of key enable or disbale"
  type        = bool
  default     = true
}

variable "enable_key_rotation" {
  description = "enable_key_rotation"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "kms_policy" {
  description = "The policy of the key usage"
  type        = string
  default     = ""
}


