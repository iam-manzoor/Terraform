terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "bucket1" {
    bucket = "backend-bucket-devops-labs" # Bucket Name
    tags = {
        Name = "Dev-Bucket"
        Environment = "Dev"
    }
}