output "bucket_name" {
  value = aws_s3_bucket.site_bucket.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.spa_distribution.domain_name
}
