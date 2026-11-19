output "cloudfront-id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "s3bucket-name" {
  value = aws_s3_bucket.staticwebsite.bucket
}