resource "aws_s3_bucket" "site_bucket" {
  bucket        = var.site_bucket_name
  force_destroy  = true

  tags = {
    Name = var.site_bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "site_bucket_block" {
  bucket                  = aws_s3_bucket.site_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "spa_oac" {
  name                              = "spa-oac"
  description                       = "OAC para acesso CloudFront ao S3"
  origin_access_control_origin_type  = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "spa_distribution" {
  enabled             = true
  comment             = var.cloudfront_comment

  origin {
    domain_name              = aws_s3_bucket.site_bucket.bucket_regional_domain_name
    origin_id                = "spaS3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.spa_oac.id
  }
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "spaS3Origin"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_iam_policy" "s3_list_bucket" {
  name        = "s3_list_bucket_policy"
  description = "Policy to allow listing of S3 bucket"
  policy      = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site_bucket.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.spa_distribution.arn]
    }
  }
}


