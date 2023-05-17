
#  Security Group Config
locals {

  saopaulo_sg_lambda = {

    sg_lambda_aws-fgt-backup = {
      description = "Security Group for Lambda function aws-fgt-backup"
      vpc_id = "vpc-09ff2860f140aad33"
      tag_product = "Security Group"
      tag_whencreated = "20230328"
    }

  }

}


#  Security Group Rule Config
locals {
  saopaulo_sgrules_lambda = {

    sgrules_lambda_aws-fgt-backup-001 = {
      type = "egress"
      from_port = "443"
      to_port = "443"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      sg_id = terraform.workspace == local.context.will-prod.workspace_label ? aws_security_group.saopaulo_lambda_sg["sg_lambda_aws-fgt-backup"].id : ""
      description = "Python Boto3 API Access"
    }
    sgrules_lambda_aws-fgt-backup-002 = {
      type = "egress"
      from_port = "22022"
      to_port = "22022"
      protocol = "tcp"
      cidr_blocks = ["10.255.255.210/32"]
      sg_id = terraform.workspace == local.context.will-prod.workspace_label ? aws_security_group.saopaulo_lambda_sg["sg_lambda_aws-fgt-backup"].id : ""
      description = "Fortigate SSH Mgmt Port"
    }

  }
}
