locals {
    bucket_name = "${var.s3_bucket}-bucket-${var.environment}"
    vpc_name = "${var.environment}-VPC"
}