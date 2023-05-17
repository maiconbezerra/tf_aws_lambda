
#  Creates security groups
resource "aws_security_group" "saopaulo_lambda_sg" {
  for_each = {for k, v in local.saopaulo_sg_lambda : k => v if terraform.workspace == local.context.will-prod.workspace_label}

  name = each.key
  description = each.value.description
  vpc_id = each.value.vpc_id

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


#  Add rules to corresponding security group
resource "aws_security_group_rule" "saopaulo_lambda_sgrule" {
  for_each = {for k, v in local.saopaulo_sgrules_lambda : k => v if terraform.workspace == local.context.will-prod.workspace_label}

  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks = each.value.cidr_blocks
  security_group_id = each.value.sg_id
  description = each.value.description
}