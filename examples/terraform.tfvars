env      = "d"
bu       = "ot"
app      = "bp"
tenant   = ""

tags     = {}

policy = {
  key-policy-1 = {
    sid           = "key-policy-1"
    effect        = "Allow"
    actions       = ["kms:*"]
    not_actions   = []
    resources     = ["*"]
    not_resources = []
    principals = [
      {
        type        = "AWS"
        identifiers = ["arn:aws:iam::340752832494:root"]
      }
    ]
  }
}

# grants = {
#   "grant1" = {
#     name              = "Grant1Name"
#     grantee_principal = "arn:aws:iam::340752832494:user/kms_user"
#     operations        = ["Encrypt", "Decrypt"]

#     constraints = {
#       encryption_context_equals = {
#         ContextKey1 = "ContextValue1"
#         ContextKey2 = "ContextValue2"
#       }
#     }

#     retiring_principal    = "arn:aws:iam::340752832494:user/kms_user"
#     grant_creation_tokens = ["token1", "token2"]
#     retire_on_delete      = true
#   }
# }
