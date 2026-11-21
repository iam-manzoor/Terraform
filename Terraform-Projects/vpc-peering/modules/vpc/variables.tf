variable "vpc_name" {
    type    = string
    description = "This VPC is used to host the web servers and the application servers."
}

variable "vpc_cidr" {
    type    = string
    description = "This is the CIDR block for the VPC."
}

variable "public_subnet_cidr" {
    type    = list(string)
}

variable "private_subnet_cidr" {
    type    = list(string)
}

variable "availability_zones" {
    type    = list(string)
}