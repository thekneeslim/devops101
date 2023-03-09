locals {
  s3_origin_id = var.identifier
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static_web_s3.bucket_regional_domain_name
    origin_id                = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.comment.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "index.html"
  price_class = "PriceClass_200"
  comment = var.identifier

  custom_error_response {
    error_code = 404
    response_page_path = "/error.html"
    response_code = 404
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["SG"]
    }
  }

  tags = {
    Environment = var.identifier
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "comment" {
  comment = "Some comment"
}