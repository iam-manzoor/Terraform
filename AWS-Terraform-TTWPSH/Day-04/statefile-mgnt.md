# Statefile management with AWS S3
- Store the terraform statefile in S3
- TF statefile contains lots of data so it can be stored in version control system.
- TF state file tracks the infra created by the `terraform apply` command.
- `terraform apply` compare the desired state with actual state.
- You have to make lot of API calls to the provider to get the details managed by the TF.
- To avoid that we use statefile.
- statefile contains confedential data.
- IMP to remember
  - Store the state file in the remote backend.
  - DO not update/delete the file
  - STate locking (S3 has inbuild feature)
  - Isolation of statefile
  - Regular backup
- Does it download and do the comparision?

```
terraform {
  backend "s3" {
    bucket = "<bucket-Name>
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true  # Lock mechanish of statefile
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "use-east-1"
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "my-s3-bucket-1234"
  tags = {
    Name = "My-bucket"
    Environment = "Dev"
  }
}
```
