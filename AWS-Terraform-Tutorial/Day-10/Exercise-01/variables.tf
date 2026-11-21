variable "environment" {
  default = "Dev"
  type    = string
}

variable "s3_bucket" {
  default = "my-s3-bucket"
  type    = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "instance_count" {
  description = "EC2 instance count"
  default     = 2
  type        = number
}

variable "monitoring" {
  type    = bool
  default = true
}

variable "associate_public_IP" {
  type    = bool
  default = true
}

variable "cidr_block" {
  type    = list(string) # list(number) as well
  default = ["10.0.0.0/16", "192.168.0.0/16", "172.16.0.0/12"]
}

variable "allowed_vm_type" {
  type    = list(string)
  default = ["t2.micro", "t3.micro", "t2.medium"]
}

# Set cannot be accessed by the index.
variable "allowed_region" {
  type    = set(string)
  default = ["us-east-1", "us-east-2", "ap-south-1", "us-east-1"]
}

variable "tags" {
  type = map(string)
  default = {
    Name        = "dev-web_instance_sg"
    Environment = "dev"
    created_by  = "terraform"
    user = "Manzoor"
  }
}

# Support Multiple data types
variable "ingress_values" {
  type    = tuple([number, string, number])
  default = [443, "tcp", 443]
}

# Object collection of multiple data types
variable "config" {
  type = object({
    region         = string,
    monitoring     = bool,
    instance_count = number
  })
  default = {
    region         = "us-east-1",
    monitoring     = true,
    instance_count = 1
  }
}

variable "bucket_names" {
  type    = list(string)
  default = ["my-bucket1-day08", "my-bucket2-day08"]
}

variable "bucket_names_set" {
    type = set(string)
    default = ["my-bucket1-set-day08","my-bucket2-set-day08"]
}

variable "ingress_rule" {
    type = list(object({
        from_port = number
        to_port = number
        protocol = string
        cidr_blocks = list(string)
        description = string
    }))
    default = [
      {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP"
      },
      {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTPS"
      }
    ]
}