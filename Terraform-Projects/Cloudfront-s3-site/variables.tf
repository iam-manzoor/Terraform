variable "region" {
  type    = string
  default = "us-east-1"
}

variable "projectname" {
  type    = string
  default = "cdn-s3-site"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Name        = "dev-bucket"
    Project     = "StaticWebSite"
  }
}