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

variable "environment" {
    default = "Dev"
    type = string
}

variable "s3_bucket" {
    default = "my-s3-bucket"
    type = string
}

locals {
    bucket_name = "${var.s3_bucket}-bucket-${var.environment}"
    vpc_name = "${var.environment}-VPC"
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = local.bucket_name
  tags = {
    Name = "${var.environment}-bucket" # String concatenation using local variable syntax
    Environment = var.environment
  }
}

resource "aws_instance" "web_instance" {
    instance_type = "t3.micro"
    ami = "ami-0bfhsbr5y3imo0eb45"
    tags = {
        Environment = var.environment
        Name = "${var.environment}-EC2-Instance" # String concatenation using local variable syntax
    }

}

resource "aws_vpc" "sample" {
    cidr_block = "10.0.1.0/24"

    tags = {
        Environment = var.environment
        Name = "${var.environment}-VPC"
    }
}

### OUTPUT variable
output "name" {
    value = aws_vpc.sample.id
}

output "ec2_id" {
    value = aws_instance.web_instance.id
}