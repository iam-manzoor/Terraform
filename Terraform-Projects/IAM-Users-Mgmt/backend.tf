terraform {
  backend "s3" {
    bucket       = "learning-tf-state-2026"
    key          = "iam-users-mgmt/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}