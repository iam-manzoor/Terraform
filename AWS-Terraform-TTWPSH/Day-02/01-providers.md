# Terraform Providers

- What are Terraform Providers?
  - Bridges the gap between the TF and the cloud-provided API
  - Provides a translation of the TF code into the code the cloud provider understands
  - Translate the HCL language to the language the cloud understands
  - `terraform init` downloads the plugin based on the provider we define
  - Providers are of various types
    - Official (AWS, Azure, GCP)
    - Partner provider
    - community providers

- Why does version matter?
  - TF version and the provider version are different from each other.
  - compatibility between the TF core version and the provider version.
  - By default, it use latest version, but the provider version might not be compatible with the latest version
  - Lock the version

- Which version to use?
  - The version for which you have developed and tested your TF configuration.
 
- Version Constraints
  - `version = "`> 6.7.0"` Provider version
  - `required_version = ">=1.0"`  Terraform Version
  - `=` Exact Version
  - `!=` Exculde the excat version
  - `>,>=,<,<=` Allow version when comparison is `true`
    - `~>1.0.4` TF can install 1.0.5 but not 1.1.0. Minor patching is allowed
    - `~> 1.1` Not 2.0
    
- First TF Script
```
terraform {
  required_version = "~> 1.8.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"
}

terraform init
terraform plan
terraform apply
```
