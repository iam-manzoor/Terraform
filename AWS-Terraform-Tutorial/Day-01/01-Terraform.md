# How does Terraform works?
- What is IAC?
  - Infrastructure As Code.
  - We write the code to provision the infrastructure in cloud.
 
- Tools for IAC
  - Terraform
  - Pulumi
  - Azure ARM | Bicep
  - AWS CloudFormation, CDK
  - Deployment Manager, COnfig COntroller/connector.
 
- Why need IAC?
  - Automation.
  - Easy provisioning of Infra
  - Versioning
  - Cost on People
  - Time
  - Repetative
  - Avoid Human Errors
  - It works on my machine (consistency on diff env)
 
- How Terraform HELPS?
  - Automate:
    - Provisioning
    - Maintenance
    - Destruction
  - Save times
  - Consistent ENVS
  - Write Once, Deploy Many 
  - Track of changes

- How Terraform works?
  - Write TF file (HCL for TF files, with tf extension)
  - Run the command such as `terraform init` `terraform validate` `terraform plan` `terraform apply`
  - It calls the AWS APIS
    - To perform the action such as provision, modify, delete the infra.
  - `terraform destroy` will delete the infra

- Terraform Installation
  - Download and install from the Hashicorp WebSite
 

- 
