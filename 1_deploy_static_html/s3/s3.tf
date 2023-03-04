resource "aws_s3_bucket" "static_web_s3" {
  bucket = "devops101-static-webpage-s3-test"
}

resource "aws_s3_bucket_policy" "static_web_s3_policy" {
  bucket = aws_s3_bucket.static_web_s3.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadForGetBucketObjects",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::devops101-static-webpage-s3-test/*"
        }
    ]
}
EOF
}

resource "aws_s3_bucket_acl" "static_web_s3_acl" {
  bucket = aws_s3_bucket.static_web_s3.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "static_web_config" {
  bucket = aws_s3_bucket.static_web_s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.static_web_s3.id
  key    = "index.html"
  source = "../resources/index.html"
  content_type = "text/html"

  etag = filemd5("../resources/index.html")
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.static_web_s3.id
  key    = "error.html"
  source = "../resources/error.html"
  content_type = "text/html"

  etag = filemd5("../resources/error.html")
}