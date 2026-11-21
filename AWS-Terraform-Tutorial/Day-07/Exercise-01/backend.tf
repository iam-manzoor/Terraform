terraform {
    backend "s3" {
        bucket = "tf-state-bucket-manz"
        key = "dev/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
        use_lockfile = true
    }
}