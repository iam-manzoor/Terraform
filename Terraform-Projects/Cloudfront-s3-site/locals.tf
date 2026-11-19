locals {
  oacname      = "${var.projectname}-oac"
  s3_origin_id = "S3-${aws_s3_bucket.staticwebsite.id}"
}