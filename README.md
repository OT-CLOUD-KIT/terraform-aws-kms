**Terraform Module: AWS KMS**


**INTRODUCTION**

The module manages AWS Key Management Service (KMS) keys and their associated resources. It provides functionality to create, configure, and manage various types of KMS keys, including symmetric default keys, external keys, replica keys, and external replica keys. Additionally, it facilitates the setup of key policies, aliases, and grants, offering a comprehensive solution for managing cryptographic keys securely within AWS.

**What this module does**

 The module appears to be defining and managing AWS KMS (Key Management Service) resources, including keys, aliases, and grants.

 - It provisions AWS KMS keys (aws_kms_key.this) with various configurations such as key specifications (customer_master_key_spec), deletion window, key rotation settings, and policies.

 - Manages IAM policies associated with the KMS keys through the data "aws_iam_policy_document" blocks.These policies define who (principals) can perform actions on which resources.

 - Creates AWS KMS aliases (aws_kms_alias.this) based on configured aliases (var.aliases) and computed aliases (var.computed_aliases). Allows setting alias names with or without name prefixes based on var.aliases_use_name_prefix.

 - Manages grants (aws_kms_grant.this) that delegate specific permissions (operations) on KMS keys to specified IAM principals (grantee_principal).

 - Grants can optionally define constraints (constraints), retiring principals (retiring_principal), grant creation tokens (grant_creation_tokens), and retirement behavior (retire_on_delete).

# Plan of Approach

**1.Design**

- The purpose of the Terraform module designed for AWS KMS (Key Management Service) is to facilitate the creation, configuration, and management of cryptographic keys within AWS environments.

1.Key Creation and Configuration: Enable users to define and provision AWS KMS keys with specific attributes such as key type, size, rotation policies, and deletion safeguards.

2.Policy Management: Implement flexible IAM policy management to enforce access controls and permissions for KMS keys across different roles and users.

3.Alias Management: Creation and management of aliases for KMS keys, providing easy-to-remember names or endpoints to reference keys.

4.Grant Permissions: Enable the delegation of permissions for specific operations to other AWS services or IAM principals, with optional constraints for enhanced security.



**2.How will we test it?**

- Develop unit tests to validate module functionality in isolated environments.

**3.Special Consideration**

- For tags variables, there is no need to pass any values. This tags will receive its value from the pipeline.

**Requirements**

| Name  | Version |
| ------ | ------ |
|   terraform      |    >=1.0    |
|       aws |   >=5.30     |

**Providers**

| Name | Version |
| ------ | ------ |
|    aws    |   5.49.0 

**Pre-Requisites**
=


**Environment variables**

| Name | Description |
| ------ | ------ |
|     AWS_ACCESS_KEY_ID   |   AWS Access Key     |
|   AWS_SECRET_ACCESS_KEY     |   AWS Secret Key
AWS_SESSION_TOKEN   |AWS Session Key
AWS_REGION | AWS Region

**Resources**

| Name  | Type |
| ------ | ------ |
|    aws_kms_alias.this    |  resource      |
|     aws_kms_external_key.this   |   resource  | header | header |
| aws_kms_grant.this| resource |
|     aws_kms_key.this   |  resource
   aws_kms_replica_external_key.this   |resource
|     aws_kms_replica_key.this   |   resource
|aws_caller_identity.current  | data source|  | header |
| aws_iam_policy_document.this | data source
aws_partition.current | data source
 

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.49 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.75.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_external_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_external_key) | resource |
| [aws_kms_grant.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_replica_external_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_external_key) | resource |
| [aws_kms_replica_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bypass_policy_lockout_safety_check"></a> [bypass\_policy\_lockout\_safety\_check](#input\_bypass\_policy\_lockout\_safety\_check) | A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable | `bool` | `false` | no |
| <a name="input_create_external"></a> [create\_external](#input\_create\_external) | Determines whether an external CMK (externally provided material) will be created or a standard CMK (AWS provided material) | `bool` | `false` | no |
| <a name="input_create_kms"></a> [create\_kms](#input\_create\_kms) | Determines whether resources will be created (affects all resources) | `bool` | `true` | no |
| <a name="input_create_replica"></a> [create\_replica](#input\_create\_replica) | Determines whether a replica standard CMK will be created (AWS provided material) | `bool` | `false` | no |
| <a name="input_create_replica_external"></a> [create\_replica\_external](#input\_create\_replica\_external) | Determines whether a replica external CMK will be created (externally provided material) | `bool` | `false` | no |
| <a name="input_custom_key_store_id"></a> [custom\_key\_store\_id](#input\_custom\_key\_store\_id) | ID of the KMS Custom Key Store where the key will be stored instead of KMS (e.g., CloudHSM). This variable is optional. If left unset (i.e., default = null), the standard KMS key store will be used. | `string` | `null` | no |
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input\_customer\_master\_key\_spec) | Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_256`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, or `ECC_SECG_P256K1`. Defaults to `SYMMETRIC_DEFAULT` | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between `7` and `30`, inclusive. If you do not specify a value, it defaults to `30` | `number` | `"7"` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the key as viewed in AWS console | `string` | `"aws kms key for encryption"` | no |
| <a name="input_enable_default_policy"></a> [enable\_default\_policy](#input\_enable\_default\_policy) | Specifies whether to enable the default key policy. Defaults to `true` | `bool` | `true` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Specifies whether key rotation is enabled. Defaults to `true` | `bool` | `true` | no |
| <a name="input_grants"></a> [grants](#input\_grants) | A map of grant definitions to create, The `default = {}` indicates that, by default, no grants are set up, allowing users to specify grants only if they are needed. | <pre>map(object({<br>    name              = string<br>    grantee_principal = string<br>    operations        = list(string)<br>    constraints = object({<br>      encryption_context_equals = map(string)<br>    })<br>    retiring_principal    = string<br>    grant_creation_tokens = list(string)<br>    retire_on_delete      = bool<br>  }))</pre> | `{}` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Specifies whether the key is enabled. Defaults to `true` | `bool` | `true` | no |
| <a name="input_key_administrators"></a> [key\_administrators](#input\_key\_administrators) | A map of key administrators with their respective properties, The default = {} means no Key administrators are defined by default so must explicitly define Key administrators in terraform configuration if needed. | <pre>map(object({<br>    sid       = string<br>    actions   = list(string)<br>    resources = list(string)<br>    principals = list(object({<br>      type        = string<br>      identifiers = list(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_key_asymmetric_public_encryption_users"></a> [key\_asymmetric\_public\_encryption\_users](#input\_key\_asymmetric\_public\_encryption\_users) | A map of IAM ARNs for key asymmetric public encryption users with their respective properties, The default = {} means no key asymmetric public encryption users are defined by default so must explicitly define key asymmetric public encryption users in terraform configuration if needed | <pre>map(object({<br>    sid       = string<br>    actions   = list(string)<br>    resources = list(string)<br>    principals = list(object({<br>      type        = string<br>      identifiers = list(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_key_asymmetric_sign_verify_users"></a> [key\_asymmetric\_sign\_verify\_users](#input\_key\_asymmetric\_sign\_verify\_users) | A map of IAM ARNs for key asymmetric sign and verify users with their respective properties, The default = {} means no key asymmetric sign verify users are defined by default so must explicitly define key asymmetric sign verify users in terraform configuration if needed | <pre>map(object({<br>    sid       = string<br>    actions   = list(string)<br>    resources = list(string)<br>    principals = list(object({<br>      type        = string<br>      identifiers = list(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_key_hmac_users"></a> [key\_hmac\_users](#input\_key\_hmac\_users) | A map of IAM ARNs for key HMAC users with their respective properties, The default = {} means no key hmac users are defined by default so must explicitly define key hmac users in terraform configuration if needed | <pre>map(object({<br>    sid       = string<br>    actions   = list(string)<br>    resources = list(string)<br>    principals = list(object({<br>      type        = string<br>      identifiers = list(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_key_material_base64"></a> [key\_material\_base64](#input\_key\_material\_base64) | Base64 encoded 256-bit symmetric encryption key material to import. The CMK is permanently associated with this key material. This is for external key use only. If left empty (default = ""), AWS KMS will generate a new key material. | `string` | `""` | no |
| <a name="input_key_owners"></a> [key\_owners](#input\_key\_owners) | A map of key owners with their respective properties, The default = {} means no key owners are defined by default so must explicitly define key owners in terraform configuration if needed. | <pre>map(object({<br>    sid       = string<br>    actions   = list(string)<br>    resources = list(string)<br>    principals = list(object({<br>      type        = string<br>      identifiers = list(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_key_service_users"></a> [key\_service\_users](#input\_key\_service\_users) | A map of IAM ARNs for key service users with their respective properties, The default = {} means no Key service users are defined by default so must explicitly define Key service users in terraform configuration if needed. | <pre>map(object({<br>    sid       = string<br>    actions   = list(string)<br>    resources = list(string)<br>    principals = list(object({<br>      type        = string<br>      identifiers = list(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_key_symmetric_encryption_users"></a> [key\_symmetric\_encryption\_users](#input\_key\_symmetric\_encryption\_users) | A map of IAM ARNs for key symmetric encryption users with their respective properties, The default = {} means no key symmetric encryption users are defined by default so must explicitly define key symmetric encryption users in terraform configuration if needed | <pre>map(object({<br>    sid       = string<br>    actions   = list(string)<br>    resources = list(string)<br>    principals = list(object({<br>      type        = string<br>      identifiers = list(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage) | Specifies the intended use of the key. Valid values: `ENCRYPT_DECRYPT` or `SIGN_VERIFY`. Defaults to `ENCRYPT_DECRYPT` | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_key_users"></a> [key\_users](#input\_key\_users) | A map of IAM ARNs for key users with their respective properties, The default = {} means no Key users are defined by default so must explicitly define Key users in terraform configuration if needed. | <pre>map(object({<br>    sid       = string<br>    actions   = list(string)<br>    resources = list(string)<br>    principals = list(object({<br>      type        = string<br>      identifiers = list(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_multi_region"></a> [multi\_region](#input\_multi\_region) | Indicates whether the KMS key is a multi-Region (`true`) or regional (`false`) key. Defaults to `false` | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of alias. Setting `default = ""` makes this variable optional, allowing the module to be used without a specific alias name if none is provided by the user. If left empty, no alias is created by default, which can be useful when testing configurations or using dynamic naming. | `string` | `""` | no |
| <a name="input_override_policy_documents"></a> [override\_policy\_documents](#input\_override\_policy\_documents) | List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid` | `list(string)` | `[]` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | Map containing IAM policy statements. If not specified, defaults to an empty map, meaning no policies are applied. | <pre>map(object({<br>    sid       = string<br>    effect    = string<br>    actions   = list(string)<br>    resources = list(string)<br>    principals = list(object({<br>      type        = string<br>      identifiers = list(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_primary_external_key_arn"></a> [primary\_external\_key\_arn](#input\_primary\_external\_key\_arn) | The primary external key arn of a multi-region replica external key, Setting `default = null` makes this variable optional, allowing configurations to proceed without specifying an ARN if a primary external key is not in use. If left null, no external primary key will be associated; define this only when creating a multi-region replica with an external key. | `string` | `null` | no |
| <a name="input_primary_key_arn"></a> [primary\_key\_arn](#input\_primary\_key\_arn) | The primary key arn of a multi-region replica key, Setting `default = null` makes this variable optional if left null, no primary key ARN is specified, and the configuration assumes a single-region setup. users should define this only when creating a multi-region key setup. | `string` | `null` | no |
| <a name="input_principal_type"></a> [principal\_type](#input\_principal\_type) | n/a | `string` | `"AWS"` | no |
| <a name="input_rotation_period_in_days"></a> [rotation\_period\_in\_days](#input\_rotation\_period\_in\_days) | Custom period of time between each rotation date. Must be a number between 90 and 2560 (inclusive) | `number` | `"365"` | no |
| <a name="input_source_policy_documents"></a> [source\_policy\_documents](#input\_source\_policy\_documents) | List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s. The default value of `[]` means no policy documents are provided by default. If no documents are required, users can leave this list empty, but they can define custom policy documents in terraform configuration as needed. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | n/a | yes |
| <a name="input_valid_to"></a> [valid\_to](#input\_valid\_to) | Time at which the imported key material expires. If not specified (default = null), the key material does not expire, and the CMK remains usable indefinitely. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aliases"></a> [aliases](#output\_aliases) | A map of aliases created and their attributes |
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the key |
| <a name="output_external_key_expiration_model"></a> [external\_key\_expiration\_model](#output\_external\_key\_expiration\_model) | Whether the key material expires. Empty when pending key material import, otherwise `KEY_MATERIAL_EXPIRES` or `KEY_MATERIAL_DOES_NOT_EXPIRE` |
| <a name="output_external_key_state"></a> [external\_key\_state](#output\_external\_key\_state) | The state of the CMK |
| <a name="output_external_key_usage"></a> [external\_key\_usage](#output\_external\_key\_usage) | The cryptographic operations for which you can use the CMK |
| <a name="output_grants"></a> [grants](#output\_grants) | A map of grants created and their attributes |
| <a name="output_id"></a> [id](#output\_id) | The globally unique identifier for the key |
| <a name="output_key_policy"></a> [key\_policy](#output\_key\_policy) | The IAM resource policy set on the key |
| <a name="output_key_usage_name"></a> [key\_usage\_name](#output\_key\_usage\_name) | usage of key |
| <a name="output_name"></a> [name](#output\_name) | KMS Alias name |
<!-- END_TF_DOCS -->

# References

- https://docs.aws.amazon.com/kms/latest/developerguide/overview.html

- https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html

- https://docs.aws.amazon.com/kms/latest/developerguide/best-practices.html




