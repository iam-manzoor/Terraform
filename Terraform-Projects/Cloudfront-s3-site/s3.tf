provider "aws" {
  region = var.region
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Bucket Creation
resource "aws_s3_bucket" "staticwebsite" {
  bucket = "${var.projectname}-${random_string.suffix.result}"
  tags   = var.tags
}

# Block all public access to bucket.
resource "aws_s3_bucket_public_access_block" "blockaccess" {
  bucket = aws_s3_bucket.staticwebsite.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Policy provides access to CloudFront
resource "aws_s3_bucket_policy" "allow_access_cdn" {
  bucket     = aws_s3_bucket.staticwebsite.id
  depends_on = [aws_s3_bucket_public_access_block.blockaccess]
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudFront",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject"
        Resource : "${aws_s3_bucket.staticwebsite.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

# Upload files to S3 from local.
resource "aws_s3_object" "staticfiles" {
  for_each = fileset("${path.module}/staticfiles", "**/*")
  bucket   = aws_s3_bucket.staticwebsite.id
  key      = each.value
  source   = "${path.module}/staticfiles/${each.value}"
  etag     = filemd5("${path.module}/staticfiles/${each.value}")
  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "json" = "application/json",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "gif"  = "image/gif",
    "svg"  = "image/svg+xml",
    "ico"  = "image/x-icon",
    "txt"  = "text/plain"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}