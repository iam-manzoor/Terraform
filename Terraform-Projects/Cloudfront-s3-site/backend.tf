# To store the backend make sure you have the bucket created.
terraform {
  backend "s3" {
    bucket       = "learning-tf-state-2026"
    key          = "cdn-s3-site/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}