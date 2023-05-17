
#  Add Lambda Layer
resource "aws_lambda_layer_version" "saopaulo_lambda_layer" {
  for_each = {for k, v in local.saopaulo_lambda_layer : k => v if terraform.workspace == local.context.will-prod.workspace_label}

  layer_name = each.key
  filename = each.value.filename
  description = each.value.description
  compatible_runtimes = each.value.compatible_runtimes
  compatible_architectures = each.value.compatible_architectures
  source_code_hash = each.value.source_code_hash
}


#  Add Lambda Function
resource "aws_lambda_function" "saopaulo_lambda_function" {
  for_each = {for k, v in local.saopaulo_lambda_functions : k => v if terraform.workspace == local.context.will-prod.workspace_label}

  function_name = each.key
  description = each.value.description
  handler = each.value.handler
  runtime = each.value.runtime
  filename = each.value.filename
  layers = each.value.layers
  role = each.value.role
  timeout = each.value.timeout
  memory_size = each.value.memory_size
  ephemeral_storage {
    size = each.value.storage_size
  }
  vpc_config {
    security_group_ids = [each.value.sg_id]
    subnet_ids = each.value.subnet_id
  }

  tags = {
    Name = each.key
    Circle = local.circle
    Environment = local.environment
    Management = local.management
    Product = each.value.tag_product
    Repository = local.repository
    Whencreated = each.value.tag_whencreated
  }

}


#  Assign Lambda Permission
resource "aws_lambda_permission" "saopaulo_lambda_permission" {
  for_each = {for k, v in local.saopaulo_lambda_permissions : k => v if terraform.workspace == local.context.will-prod.workspace_label}

  statement_id = each.value.statement_id
  action        = each.value.action
  function_name = each.value.function_name
  principal     = each.value.principal
}