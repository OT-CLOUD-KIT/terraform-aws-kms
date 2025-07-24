###########################
# General Configuration
###########################
create_kms                = true
create_external           = false
create_replica            = false
create_replica_external   = false


###########################
# KMS Key Configuration
###########################
bypass_policy_lockout_safety_check = false
customer_master_key_spec           = "SYMMETRIC_DEFAULT"
custom_key_store_id                = null
deletion_window_in_days            = 7
description                        = "Example KMS key for encryption"
enable_key_rotation                = true
is_enabled                         = true
key_material_base64                = ""
key_usage                          = "ENCRYPT_DECRYPT"
multi_region                       = false
rotation_period_in_days            = 365
valid_to                           = null

###########################
# Policy Configuration
###########################
enable_default_policy     = false
principal_type            = "AWS"
source_policy_documents   = []
override_policy_documents = []

###########################
# Custom Inline Policy
###########################
policy = {
  "custom-policy-statement-1" = {
    sid       = "CustomPolicyStatement"
    effect    = "Allow"
    actions   = ["kms:Encrypt", "kms:Decrypt"]
    resources = ["*"]
    principals = [
      {
        type        = "AWS"
        identifiers = [
          "arn:aws:iam::509633460021:user/Nikita"
        ]
      }
    ]
  }
}

###########################
# Key Owners
###########################
key_owners = {
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

###########################
# Key Administrators
###########################
key_administrators = {
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

###########################
# Key Users
###########################
key_users = {
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

###########################
# Key Service Users
###########################
key_service_users = {}

###########################
# Other User Types
###########################
key_symmetric_encryption_users           = {}
key_hmac_users                           = {}
key_asymmetric_public_encryption_users  = {}
key_asymmetric_sign_verify_users        = {}

###########################
# Replica Config
###########################
primary_key_arn          = null
primary_external_key_arn = null

###########################
# Grants
###########################
grants = {
  "grant-app" = {
    name              = "AppGrant"
    grantee_principal = "arn:aws:iam::509633460021:user/aayush"
    operations        = ["Encrypt", "Decrypt"]

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

random_alphanumeric_len = 4

bu       = "ot"
app      = "bp"
env      = "d"
resource = "KMS"
tenant   = ""

special = false
upper   = false
number  = true

gen_no_of_names = 1

team    = "infra"
program = "ot"

