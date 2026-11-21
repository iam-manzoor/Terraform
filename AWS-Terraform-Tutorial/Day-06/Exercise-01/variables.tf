variable "environment" {
    default = "Dev"
    type = string
}

variable "s3_bucket" {
    default = "my-s3-bucket"
    type = string
}

variable "region" {
    default = "us-east-1"
    type = string
}