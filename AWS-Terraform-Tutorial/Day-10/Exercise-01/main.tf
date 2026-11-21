resource "aws_instance" "conditional_instance" {
  ami           = "ami-0ff8a91507f77f867"
  count        = var.instance_count
  #instance_type = "t3.micro"
  instance_type = var.environment == "dev" ? "t3.large" : "t3.micro"

  tags = var.tags
}

## Without using dynamic block
# resource "aws_security_group" "conditional_sg" {
#   name        = "conditional_sg"
#   description = "Security group with conditional rules"

#   ingress {
#     from_port   = var.monitoring ? 22 : 80
#     to_port     = var.monitoring ? 22 : 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     }

#     tags = var.tags
# }

# With Dynamic block
resource "aws_security_group" "conditional_sg1" {
  name        = "conditional_sg1"
  description = "Security group with conditional rules"

  dynamic "ingress" {
    for_each = var.ingress_rule
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
}
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

    tags = var.tags
}