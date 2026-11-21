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
