### Features implementadas aqui

- Adição de funções Lambda e scripts relacionados;
- Adição de Lambda Layers;
- Associação de Lambda Permission;
- Criação Roles e Policies para funções Lambda;
- Criação de Security Group para funções Lambda.

**Tabela de Conteúdo**

[TOC]

#Como utilizar IAM
##IAM Policy
Para adicionar uma nova policy o seguinte bloco deverá ser adicionado no arquivo de configuração chamado **iam_locals.tf** localizado na pasta raiz:
```
	pol-ec2net-manipulation = {
      description = ""
      policy = file("./iam_policy/pol-ec2net-manipulation.json")
      tag_name = "pol-ec2net-manipulation"
      tag_product = "IAM"
	}
```
Como atividade complementar o arquivo **.json** contendo as permissões implementadas pela policy deverão ser colocados na pasta chamada **iam_policy** e referenciadas no código conforme exemplo acima. Lembre-se de seguir o padrão **policy-name.json** para o arquivo.

##IAM Role
Para adicionar uma nova role o seguinte bloco deverá ser adicionado no arquivo de configuração chamado **iam_locals.tf** localizado na pasta raiz:
```
	lambda-fgt-backup = {
      description = "Allows Lambda functions to call AWS services on your behalf."
      role_policy = file("./iam_role/lambda-fgt-backup.json")
      tag_name = "lambda-fgt-backup"
      tag_product = "IAM"
    }
```
Como atividade complementar o arquivo **.json** contendo as permissões implementadas pela role deverão ser colocados na pasta chamada **iam_role** e referenciadas no código conforme exemplo acima. Lembre-se de seguir o padrão **role-name.json** para o arquivo.

##IAM Role Attachment
Para associar as policies criadas anteriormente a role o seguinte bloco deverá ser adicionado no arquivo de configuração chamado **iam_locals.tf** localizado na pasta raiz:
```
	lambda-fgt-backup_attach-001 = {
      role = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_role.saopaulo_lambda_role["lambda-fgt-backup"].name : ""
      policy = terraform.workspace == local.context.will-prod.workspace_label ? aws_iam_policy.saopaulo_lambda_pol["pol-ec2net-manipulation"].arn : ""
    }
```
Por questões de padronização a key deverá ser composta da seguinte maneira:
**role_name_attach-[3 digitos crescentes]**. O attach é feito para cada policy a ser associada, conforme exemplo acima que associa a policy **pol-ec2net-manipulation** a role **lambda-fgt-backup**.

#Como utilizar Security Group
##Security Group
Para adicionar um novo security group o seguinte bloco deverá ser adicionado no arquivo de configuração chamado **sg_locals.tf** localizado na pasta raiz:
```
	sg_lambda_aws-fgt-backup = {
      description = "Security Group for Lambda function aws-fgt-backup"
      vpc_id = "vpc-09ff2860f140aad33"
      tag_product = "Security Group"
      tag_whencreated = "20230328"
    }
```
***Observação*** A configuração acima apenas cria um security group vazio. Para adicionar regras ao novo security group criado, siga para o próximo tópico.

##Security Group Rule
Para adicionar uma nova security group rule a um SG pré-existente, o seguinte bloco deverá ser adicionado no arquivo de configuração chamado **sg_locals.tf** localizado na pasta raiz:
```
	sgrules_lambda_aws-fgt-backup-001 = {
      type = "egress"
      from_port = "443"
      to_port = "443"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      sg_id = terraform.workspace == local.context.will-prod.workspace_label ? aws_security_group.saopaulo_lambda_sg["sg_lambda_aws-fgt-backup"].id : ""
      description = "Python Boto3 API Access"
    }
```
***Observação*** Deverá ser adicionado um bloco de configuração para cada fluxo de regra seja ele inbound ou outbound. O exemplo acima cria apenas um fluxo de saída.

#Lambda Configuration
##Lambda Layer
O recurso Lambda Layer é utilizado quando é necessário utilizar libraries não nativas da lingugem utilizada.
Para adicionar uma nova layer, o seguinte bloco deverá ser adicionado no arquivo de configuração chamado **lambda_locals.tf** localizado na pasta raiz:
```
	python_netmiko = {
      filename = "./lambda_layers/netmiko.zip"
      description = "Python Netmiko version 4"
      compatible_runtimes = ["python3.9"]
      compatible_architectures = ["x86_64"]
      source_code_hash = "${filebase64sha256("./lambda_layers/netmiko.zip")}"
    }
```
***Observação*** Os arquivos que compõe a library a ser importada deve estar no formato **.zip** e deverão ser armazenados na pasta **lambda_layers**. Em alguns cenários é recomendado a geração do arquivo em uma instância Amazon Linux. Para mais informações sobre como gerar o pacote, acesse o link a seguir:

https://contameupag.atlassian.net/wiki/spaces/TF/pages/2705293313/Lambda+Backup+-+Fortigate+AWS

Caso não deseje implementar nenhuma library adicional, nenhuma alteração se faz necessária.

##Lambda Function
Para adicionar uma nova função Lambda, o seguinte bloco deverá ser adicionado no arquivo de configuração chamado **lambda_locals.tf** localizado na pasta raiz:
```
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
```
***Observação*** Os scripts utilizados pela função deverão ser armazenados na pasta **lambda_scripts** no formato **.zip** e todas as configurações layers, role, security groups definidas anteriormente, devem ser referenciadas aqui, seguindo o exemplo acima.

##Lambda Permission
O recurso Lambda permission é utilizado apenas quando houver integração com serviços externos que fazem chamadas lambda, sendo necessário conceder os privilégios necessários para tal ação.
Para associar uma permissão a uma função lambda, o seguinte bloco deverá ser adicionado no arquivo de configuração chamado **lambda_locals.tf** localizado na pasta raiz:
```
	fgt-bkp-randompass_permissions = {
      statement_id = "SecretsLambdaInvoke"
      action = "lambda:InvokeFunction"
      function_name = terraform.workspace == local.context.will-prod.workspace_label ? aws_lambda_function.saopaulo_lambda_function["fgt-bkp-randompass"].arn : ""
      principal = "secretsmanager.amazonaws.com"
    }
```