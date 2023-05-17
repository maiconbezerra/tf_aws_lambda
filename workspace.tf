
data "aws_caller_identity" "current" {}


#  Environment context config
locals {
  context = {
    will-prod = {
      nomenclature  = ["will-network", "prod", "Production"]
      profile       = "will-network"
      region        = "sa-east-1"
      origin_vpc_id = "vpc-0d1c68d3bc6a4cce7"
      workspace_label = "will-prod"
    }
    will-dev = {
      nomenclature  = ["will-network", "dev", "Development"]
      profile       = "will-network"
      region        = "us-east-1"
      origin_vpc_id = "vpc-083af4b76a116c1c9"
      workspace_label = "will-dev"
    }
    will-stg = {
      nomenclature  = ["will-network", "stg", "Staging"]
      profile       = "will-network"
      region        = "us-east-2"
      origin_vpc_id = "vpc-0bb222a651bc1b1ec"
      workspace_label = "will-stg"
    }
 }
}


#  Building variables used in cod
locals {
  workspace   = local.context[terraform.workspace]
  region      = local.workspace.region
  prefix      = local.workspace.nomenclature[0]
  environment = local.workspace.nomenclature[1]
  env_tag     = local.workspace.nomenclature[2]
  workspace_label = local.workspace.workspace_label
  account_id  = data.aws_caller_identity.current.account_id
  management  = "Managed by Terraform"
  repository  = "https://bitbucket.org/will-bank/will-terraform-network"
  circle      = "Plataform Engineering"
}
