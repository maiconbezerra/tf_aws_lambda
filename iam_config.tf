
#  Manages IAM Policy
resource "aws_iam_policy" "saopaulo_lambda_pol" {
  for_each = {for k, v in local.saopaulo_lambda_pol : k => v if terraform.workspace == local.context.will-prod.workspace_label}

  name        = each.key
  description = each.value.description
  policy = each.value.policy

  tags = {
    Name = each.value.tag_name
    Environment = local.environment
    Management = local.management
    Circle = local.circle
    Product = each.value.tag_product
    Repository = local.repository
  }
}


#  Manages IAM role
resource "aws_iam_role" "saopaulo_lambda_role" {
  for_each = {for k, v in local.saopaulo_lambda_rol : k => v if terraform.workspace == local.context.will-prod.workspace_label}

  name        = each.key
  description = each.value.description
  assume_role_policy = each.value.role_policy

  tags = {
    Name = each.key
    Environment = local.environment
    Management = local.management
    Circle = local.circle
    Product = each.value.tag_product
    Repository = local.repository
  }

  depends_on = [aws_iam_policy.saopaulo_lambda_pol]
}


#  Attach IAM policy to role
resource "aws_iam_role_policy_attachment" "saopaulo_lambda_roleattch" {
  for_each = {for k, v in local.saopaulo_lambda_rolattach : k => v if terraform.workspace == local.context.will-prod.workspace_label}

  role       = each.value.role
  policy_arn = each.value.policy

  depends_on = [aws_iam_policy.saopaulo_lambda_pol, aws_iam_role.saopaulo_lambda_role]
}
