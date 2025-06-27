# Projeto Terraform: SPA Estático AWS (S3 + CloudFront)

Este projeto provisiona uma stack AWS para hospedagem de um site SPA estático, utilizando S3 (sem acesso público) e CloudFront com Origin Access Control (OAC).

## Recursos criados
- Bucket S3 privado para arquivos do site
- CloudFront Distribution com OAC
- Policy do bucket permitindo acesso apenas via CloudFront
- Permissões IAM necessárias

## Como usar
1. Configure suas credenciais AWS (ex: via AWS CLI ou variáveis de ambiente)
2. Edite o arquivo `terraform.tfvars` ou defina as variáveis necessárias
3. Execute:
   ```
   terraform init
   terraform apply
   ```

## Variáveis principais
- `aws_region`: Região AWS (default: us-east-1)
- `site_bucket_name`: Nome do bucket S3

## Outputs
- `bucket_name`: Nome do bucket S3
- `cloudfront_domain_name`: URL da distribuição CloudFront
