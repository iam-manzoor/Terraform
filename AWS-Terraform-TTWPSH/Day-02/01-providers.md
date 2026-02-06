# Terraform Providers

- What are Terraform Providers?
  - Bridges the gap between the TF and the cloud provided API
  - Provides translates the TF code into the code the cloud provider understands
  - Translate the HCL language to the language the cloud understands
  - `terraform init` downloads the plugin based on the provider we define
  - Providres are of various types
    - Official (AWS, Azure, GCP)
    - Partner provider
    - community providers

- Why version matters?
  - TF version and the provider version are different from each other.
  - compatibility between the TF core version and the provider version.
  - By default it use latest version but the provider version might not be compatiable with the latest version
  - Lock the version

- Which version to use?
  - The version for which you have developed and tested your TF configuration.
 
- Version Constraints
  - `version = "`> 6.7.0"` Provider version
  - `required_version = ">=1.0"`  Terraform Version
  - `=` Exact Version
  - `!=` Exculde the excat version
  - `>,>=,<,<=` Aloow version when comparision is `true`
    - `~>1.0.4` TF can install 1.0.5 but not 1.1.0. Minor patching is allowed
    - `~> 1.1` Not 2.0
    
