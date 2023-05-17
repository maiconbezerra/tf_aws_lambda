
#  Add lambda layer - When need to use custom library
locals {

  saopaulo_lambda_layer = {

    python_netmiko = {
      filename = "./lambda_layers/netmiko.zip"
      description = "Python Netmiko version 4"
      compatible_runtimes = ["python3.9"]
      compatible_architectures = ["x86_64"]
      source_code_hash = "${filebase64sha256("./lambda_layers/netmiko.zip")}"
    }
    python_requests = {
      filename = "./lambda_layers/requests.zip"
      description = "Python Requests version 2"
      compatible_runtimes = ["python3.9"]
      compatible_architectures = ["x86_64"]
      source_code_hash = "${filebase64sha256("./lambda_layers/requests.zip")}"
    }

  }
}


#  Add Lambda Function and Script files
locals {

  saopaulo_lambda_functions = {

    aws-fgt-backup = {
      description = "Script to backup Fortigate Active-Passive Cluster"
      filename = "./lambda_scripts/aws-fgt-backup.zip"
      handler = "fgt_session.lambda_handler"
      runtime = "python3.9"
      layers = [terraform.workspace == local.context.will-prod.workspace_label ? "${aws_lambda_layer_version.saopaulo_lambda_layer["python_netmiko"].arn}" : "",]
      timeout = 300
      memory_size = 128
      storage_size = 512
      role = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_role.saopaulo_lambda_role["lambda-fgt-backup"].arn : ""
      sg_id = terraform.workspace == local.context.will-prod.workspace_label ? aws_security_group.saopaulo_lambda_sg["sg_lambda_aws-fgt-backup"].id : ""
      subnet_id = ["subnet-0f1a2b6ce0dd15ba3", "subnet-0e30b4d024e35c96b"]
      tag_product = "Lambda"
      tag_whencreated = "20230328"
    }
    fgt-bkp-randompass = {
      description = "Script to random Fortigate user backup password"
      filename = "./lambda_scripts/fgt-bkp-randompass.zip"
      handler = "fgt_randompass.lambda_handler"
      runtime = "python3.9"
      layers = [terraform.workspace == local.context.will-prod.workspace_label ? "${aws_lambda_layer_version.saopaulo_lambda_layer["python_netmiko"].arn}" : "",]
      timeout = 60
      memory_size = 128
      storage_size = 512
      role = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_role.saopaulo_lambda_role["lambda-fgt-randompass"].arn : ""
      sg_id = terraform.workspace == local.context.will-prod.workspace_label ? aws_security_group.saopaulo_lambda_sg["sg_lambda_aws-fgt-backup"].id : ""
      subnet_id = ["subnet-0f1a2b6ce0dd15ba3", "subnet-0e30b4d024e35c96b"]
      tag_product = "Lambda"
      tag_whencreated = "20230328"
    }

  }

}


#  Add Lambda Resource-based policy statements
locals {

  saopaulo_lambda_permissions = {

    fgt-bkp-randompass_permissions = {
      statement_id = "SecretsLambdaInvoke"
      action = "lambda:InvokeFunction"
      function_name = terraform.workspace == local.context.will-prod.workspace_label ? aws_lambda_function.saopaulo_lambda_function["fgt-bkp-randompass"].arn : ""
      principal = "secretsmanager.amazonaws.com"
    }

  }

}