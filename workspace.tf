
data "aws_caller_identity" "current" {}


#  Environment context config
locals {
  context = {
    will-prod = {
      nomenclature    = ["name1", "prod", "Production"]
      profile         = "profilename"
      region          = "sa-east-1"
      origin_vpc_id   = "vpc-11111111111111111"
      workspace_label = "prod"
    }
    will-dev = {
      nomenclature    = ["name2", "dev", "Development"]
      profile         = "profilename"
      region          = "us-east-1"
      origin_vpc_id   = "vpc-22222222222222222"
      workspace_label = "dev"
    }
    will-stg = {
      nomenclature    = ["name3", "stg", "Staging"]
      profile         = "profilename"
      region          = "us-east-2"
      origin_vpc_id   = "vpc-33333333333333333"
      workspace_label = "stg"
    }

  }
}


#  Building variables used in cod
locals {
  workspace       = local.context[terraform.workspace]
  region          = local.workspace.region
  prefix          = local.workspace.nomenclature[0]
  environment     = local.workspace.nomenclature[1]
  env_tag         = local.workspace.nomenclature[2]
  workspace_label = local.workspace.workspace_label
  account_id      = data.aws_caller_identity.current.account_id
  management      = "Managed by Terraform"
  repository      = "https://github.com/reponame"
  circle          = "Team name"
}
