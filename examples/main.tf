module "standard_tags" {
  source = "git@github.com:OT-CLOUD-KIT/terraform-aws-standard-tagging.git?ref=dev"
  env     = var.env
  app     = var.app
  bu      = var.bu
  program = "cloud"
  team    = "cloud-kit"
  region  = "ap-south-1"
}

module "name_sg" {
  source   = "git@github.com:OT-CLOUD-KIT/terraform-aws-naming.git?ref=dev"
  bu       = var.bu
  env      = var.env
  app      = var.app
  tenant   = var.tenant
  resource = "kms"
}

module "kms_terraform" {
  source     = "../"
  create_kms = var.create_kms
  tags       = module.standard_tags.standard_tags
  policy     = var.policy
  grants     = var.grants
  name       = module.name_sg.naming_tag[0]
}
