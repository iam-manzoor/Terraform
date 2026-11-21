terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0"
        }
    }

    backend "s3" {
        bucket = "tf-state-bucket-manz"
        key = "dev/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
        use_lockfile = true
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "my-s3-bucket-1234"
  tags = {
    Name = "My-bucket"
    Environment = "Dev"
  }
}