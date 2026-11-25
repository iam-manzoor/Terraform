terraform {
  backend "s3" {
    bucket       = "learning-tf-state-2026"
    key          = "terraform-aws-eks/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}