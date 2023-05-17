
#  Config IAM Policy
locals {

  saopaulo_lambda_pol = {

    pol-ec2net-manipulation = {
      description = ""
      policy = file("./iam_policy/pol-ec2net-manipulation.json")
      tag_name = "pol-ec2net-manipulation"
      tag_product = "IAM"
    }
    pol-s3access-networkbackups = {
      description = "Acesso restrito ao bucket will-network-backups"
      policy = file("./iam_policy/pol-s3access-networkbackups.json")
      tag_name = "pol-s3access-networkbackups"
      tag_product = "IAM"
    }
    pol-secretsmgr-lambdafgtbkp = {
      description = ""
      policy = file("./iam_policy/pol-secretsmgr-lambdafgtbkp.json")
      tag_name = "pol-secretsmgr-lambdafgtbkp"
      tag_product = "IAM"
    }
    pol-sns-lambdafgtbkp = {
      description = ""
      policy = file("./iam_policy/pol-sns-lambdafgtbkp.json")
      tag_name = "pol-sns-lambdafgtbkp"
      tag_product = "IAM"
    }
    pol-secretsmgr-fgtrandompass = {
      description = "Allow to get and put secret value in lambda fgt_backup"
      policy = file("./iam_policy/pol-secretsmgr-fgtrandompass.json")
      tag_name = "pol-secretsmgr-fgtrandompass"
      tag_product = "IAM"
    }

  }

}


#  Config IAM Role
locals {

  saopaulo_lambda_rol = {

    lambda-fgt-backup = {
      description = "Allows Lambda functions to call AWS services on your behalf."
      role_policy = file("./iam_role/lambda-fgt-backup.json")
      tag_name = "lambda-fgt-backup"
      tag_product = "IAM"
    }
    lambda-fgt-randompass = {
      description = "Allows Lambda functions to call AWS services on your behalf."
      role_policy = file("./iam_role/lambda-fgt-randompass.json")
      tag_name = "lambda-fgt-randompass"
      tag_product = "IAM"
    }

  }

}

#  Config Role Policy Attachment
locals {

  saopaulo_lambda_rolattach = {
    lambda-fgt-backup_attach-001 = {
      role = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_role.saopaulo_lambda_role["lambda-fgt-backup"].name : ""
      policy = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_policy.saopaulo_lambda_pol["pol-ec2net-manipulation"].arn : ""
    }
    lambda-fgt-backup_attach-002 = {
      role = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_role.saopaulo_lambda_role["lambda-fgt-backup"].name : ""
      policy = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_policy.saopaulo_lambda_pol["pol-s3access-networkbackups"].arn : ""
    }
    lambda-fgt-backup_attach-003 = {
      role = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_role.saopaulo_lambda_role["lambda-fgt-backup"].name : ""
      policy = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_policy.saopaulo_lambda_pol["pol-secretsmgr-lambdafgtbkp"].arn : ""
    }
    lambda-fgt-backup_attach-004 = {
      role = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_role.saopaulo_lambda_role["lambda-fgt-backup"].name : ""
      policy = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_policy.saopaulo_lambda_pol["pol-sns-lambdafgtbkp"].arn : ""
    }
    lambda-fgt-randompass_attach-001 = {
      role = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_role.saopaulo_lambda_role["lambda-fgt-randompass"].name : ""
      policy = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_policy.saopaulo_lambda_pol["pol-ec2net-manipulation"].arn : ""
    }
    lambda-fgt-randompass_attach-002 = {
      role = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_role.saopaulo_lambda_role["lambda-fgt-randompass"].name : ""
      policy = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_policy.saopaulo_lambda_pol["pol-secretsmgr-fgtrandompass"].arn : ""
    }

  }

}

