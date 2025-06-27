variable "aws_region" {
  description = "Região AWS para deploy."
  type        = string
  default     = "us-east-1"
}

variable "site_bucket_name" {
  description = "Nome do bucket S3 para o site."
  type        = string
}

variable "cloudfront_comment" {
  description = "Comentário para a distribuição CloudFront."
  type        = string
  default     = "SPA Static Site Distribution"
}
