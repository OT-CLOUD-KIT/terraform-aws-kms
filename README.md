# Terraform AWS KMS (Key Management Service)

A Terraform module to create and manage AWS KMS keys (symmetric or asymmetric), with support for external keys, multi-region replication, aliases, and grants, including fine-grained IAM policies.


## Architecture

![KMS](https://github.com/user-attachments/assets/7893fc64-d84e-4928-b854-9182bd836298)

> **Note** :
   This diagram illustrates a standard symmetric key deployment with alias and grant setup. This module supports:
   - Internal and external keys

   - Multi-region replicas

  -  Aliases and key grants

  -   Custom IAM policy structure

  ___


  ## Providers

| Name                                              | Version  |
|---------------------------------------------------|----------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2   |
| <a name="terraform_module"></a> [Terraform](Terraform\module) | >= 1.12.1|

___

## Usage

```hcl
module "kms" {
  source = "OT-CLOUD-KIT/terraform-aws-kms"

  create_kms                = true
  create_external           = false
  create_replica            = false
  create_replica_external   = false
  name                      = module.naming.naming_tag[0]
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

  # Policy Config
  enable_default_policy     = false
  principal_type            = "AWS"
  source_policy_documents   = []
  override_policy_documents = []

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

  key_service_users                      = {}
  key_symmetric_encryption_users        = {}
  key_hmac_users                        = {}
  key_asymmetric_public_encryption_users = {}
  key_asymmetric_sign_verify_users      = {}

  # Replica settings
  primary_key_arn          = null
  primary_external_key_arn = null

  # Grants
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
}


```


___

## Resource

| Name                                                                                                                                     | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws\_kms\_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)                                     | resource    |
| [aws\_kms\_external\_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_external_key)                  | resource    |
| [aws\_kms\_replica\_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key)                    | resource    |
| [aws\_kms\_replica\_external\_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_external_key) | resource    |
| [aws\_kms\_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias)                                 | resource    |
| [aws\_kms\_grant](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant)                                 | resource    |
| [aws\_iam\_policy\_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)         | data source |
| [aws\_caller\_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                  | data source |

___



## Inputs

| Name                                                                                                                                                    | Description                                                 | Type           | Default              | Required |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- | -------------- | -------------------- | :------: |
| <a name="input_create_kms"></a> [create\_kms](#input_create_kms)                                                                                        | Whether to create a KMS key                                 | `bool`         | `false`              |     Yes   |
| <a name="input_create_external"></a> [create\_external](#input_create_external)                                                                         | Whether to create an external KMS key                       | `bool`         | `false`              |    No    |
| <a name="input_create_replica"></a> [create\_replica](#input_create_replica)                                                                            | Whether to create a replica KMS key                         | `bool`         | `false`              |    No    |
| <a name="input_create_replica_external"></a> [create\_replica\_external](#input_create_replica_external)                                                | Whether to create a replica external KMS key                | `bool`         | `false`              |    No    |
| <a name="input_name"></a> [name](#input_name)                                                                                                           | Name to be used in the alias                                | `string`       | n/a                  |     Yes   |
| <a name="input_bypass_policy_lockout_safety_check"></a> [bypass\_policy\_lockout\_safety\_check](#input_bypass_policy_lockout_safety_check)             | Whether to bypass the key policy lockout safety check       | `bool`         | `false`              |    No    |
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input_customer_master_key_spec)                                            | The type of KMS key to create                               | `string`       | "SYMMETRIC\_DEFAULT" |     Yes   |
| <a name="input_custom_key_store_id"></a> [custom\_key\_store\_id](#input_custom_key_store_id)                                                           | Custom key store ID to use                                  | `string`       | `null`               |    No    |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input_deletion_window_in_days)                                               | Waiting period for key deletion                             | `number`       | `7`                  |     Yes   |
| <a name="input_description"></a> [description](#input_description)                                                                                      | Description of the key                                      | `string`       | `""`                 |    No    |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input_enable_key_rotation)                                                            | Whether to enable key rotation                              | `bool`         | `true`               |    No    |
| <a name="input_is_enabled"></a> [is\_enabled](#input_is_enabled)                                                                                        | Whether the key is enabled                                  | `bool`         | `true`               |     Yes   |
| <a name="input_key_material_base64"></a> [key\_material\_base64](#input_key_material_base64)                                                            | Base64-encoded key material for external keys               | `string`       | `""`                 |    No    |
| <a name="input_key_usage"></a> [key\_usage](#input_key_usage)                                                                                           | The cryptographic operations for which the key can be used  | `string`       | "ENCRYPT\_DECRYPT"   |     Yes   |
| <a name="input_multi_region"></a> [multi\_region](#input_multi_region)                                                                                  | Whether this is a multi-region key                          | `bool`         | `false`              |    No    |
| <a name="input_rotation_period_in_days"></a> [rotation\_period\_in\_days](#input_rotation_period_in_days)                                               | Custom rotation period in days                              | `number`       | `365`                |    No    |
| <a name="input_valid_to"></a> [valid\_to](#input_valid_to)                                                                                              | Expiry date for imported key material                       | `string`       | `null`               |    No    |
| <a name="input_enable_default_policy"></a> [enable\_default\_policy](#input_enable_default_policy)                                                      | Whether to enable the default key policy                    | `bool`         | `false`              |    No    |
| <a name="input_principal_type"></a> [principal\_type](#input_principal_type)                                                                            | Type of IAM principal (e.g., `AWS`)                         | `string`       | "AWS"                |     Yes   |
| <a name="input_source_policy_documents"></a> [source\_policy\_documents](#input_source_policy_documents)                                                | List of IAM policy documents to include                     | `list(string)` | `[]`                 |    No    |
| <a name="input_override_policy_documents"></a> [override\_policy\_documents](#input_override_policy_documents)                                          | List of IAM policy documents to override defaults           | `list(string)` | `[]`                 |    No    |
| <a name="input_policy"></a> [policy](#input_policy)                                                                                                     | Custom IAM policy for the KMS key                           | `map(any)`     | `{}`                 |    No    |
| <a name="input_key_owners"></a> [key\_owners](#input_key_owners)                                                                                        | Key policy statements for key owners                        | `map(any)`     | `{}`                 |    No    |
| <a name="input_key_administrators"></a> [key\_administrators](#input_key_administrators)                                                                | Key policy statements for key admins                        | `map(any)`     | `{}`                 |    No    |
| <a name="input_key_users"></a> [key\_users](#input_key_users)                                                                                           | Key policy statements for key users                         | `map(any)`     | `{}`                 |    No    |
| <a name="input_key_service_users"></a> [key\_service\_users](#input_key_service_users)                                                                  | Statements for service principals                           | `map(any)`     | `{}`                 |    No    |
| <a name="input_key_symmetric_encryption_users"></a> [key\_symmetric\_encryption\_users](#input_key_symmetric_encryption_users)                          | Policy for symmetric encryption users                       | `map(any)`     | `{}`                 |    No    |
| <a name="input_key_hmac_users"></a> [key\_hmac\_users](#input_key_hmac_users)                                                                           | Policy for HMAC key users                                   | `map(any)`     | `{}`                 |    No    |
| <a name="input_key_asymmetric_public_encryption_users"></a> [key\_asymmetric\_public\_encryption\_users](#input_key_asymmetric_public_encryption_users) | Policy for asymmetric public encryption users               | `map(any)`     | `{}`                 |    No    |
| <a name="input_key_asymmetric_sign_verify_users"></a> [key\_asymmetric\_sign\_verify\_users](#input_key_asymmetric_sign_verify_users)                   | Policy for asymmetric sign/verify users                     | `map(any)`     | `{}`                 |    No    |
| <a name="input_primary_key_arn"></a> [primary\_key\_arn](#input_primary_key_arn)                                                                        | ARN of the primary key (for replica keys)                   | `string`       | `null`               |    No    |
| <a name="input_primary_external_key_arn"></a> [primary\_external\_key\_arn](#input_primary_external_key_arn)                                            | ARN of the primary external key (for replica external keys) | `string`       | `null`               |    No    |
| <a name="input_grants"></a> [grants](#input_grants)                                                                                                     | Map of grants to apply to the KMS key                       | `map(any)`     | `{}`                 |    No    |


___



 ## Output

 | Name                                                                                                                          | Description                                                                                                                                  |
| ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| <a name="output_arn"></a> [arn](#output_arn)                                                                                  | The Amazon Resource Name (ARN) of the key                                                                                                    |
| <a name="output_id"></a> [id](#output_id)                                                                                     | The globally unique identifier for the key                                                                                                   |
| <a name="output_name"></a> [name](#output_name)                                                                               | KMS Alias name                                                                                                                               |
| <a name="output_key_policy"></a> [key\_policy](#output_key_policy)                                                            | The IAM resource policy set on the key                                                                                                       |
| <a name="output_external_key_expiration_model"></a> [external\_key\_expiration\_model](#output_external_key_expiration_model) | Whether the key material expires. Empty when pending key material import, otherwise `KEY_MATERIAL_EXPIRES` or `KEY_MATERIAL_DOES_NOT_EXPIRE` |
| <a name="output_external_key_state"></a> [external\_key\_state](#output_external_key_state)                                   | The state of the CMK                                                                                                                         |
| <a name="output_external_key_usage"></a> [external\_key\_usage](#output_external_key_usage)                                   | The cryptographic operations for which you can use the CMK                                                                                   |
| <a name="output_aliases"></a> [aliases](#output_aliases)                                                                      | A map of aliases created and their attributes                                                                                                |
| <a name="output_grants"></a> [grants](#output_grants)                                                                         | A map of grants created and their attributes                                                                                                 |
| <a name="output_key_usage_name"></a> [key\_usage\_name](#output_key_usage_name)                                               | Usage of key                                                                                                                                 |
___


## Contributors

- [Piyush Upadhyay](https://github.com/piiiyuushh)
- [Nikita Joshi](https://github.com/jnikita19)




- [Piyush Upadhyay](https://github.com/piiiyuushh)
- [Nikita Joshi](https://github.com/jnikita19)


