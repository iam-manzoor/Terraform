# Azure + Terraform – 50 Most Asked Interview Questions with Answers

Bhai, ab sirf questions nahi, interview mein bolne layak answers, practical examples aur production scenarios ke saath prepare karte hain.

Answers English mein rakhe hain taaki candidate directly interview mein explain kar sake. Jahan zaroori hai, wahan Hinglish explanation bhi di hai.

# Section 1: Terraform Fundamentals

## Q1. What is Terraform? Why do we use it in Azure?

Answer:

Terraform is an Infrastructure as Code (IaC) tool developed by HashiCorp. It allows us to provision and manage Azure infrastructure using declarative configuration files written in HCL.

We use Terraform to:

- Automate infrastructure provisioning.
- Maintain consistent infrastructure across environments.
- Reuse code through modules.
- Track infrastructure changes through Git.
- Integrate infrastructure deployment with CI/CD pipelines.
- Manage infrastructure lifecycle.

Example:

```
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-devops-prod"
  location = "Central India"
}
```

## Q2. What is the difference between Terraform and ARM Templates?

Answer:

| Terraform               | ARM Template                     |
| ----------------------- | -------------------------------- |
| Uses HCL                | Uses JSON                        |
| Multi-cloud             | Azure-specific                   |
| Maintains state         | No Terraform-style state file    |
| Supports modules        | Supports linked/nested templates |
| Uses providers          | Uses Azure Resource Manager      |
| Supports many providers | Primarily Azure                  |

Interview explanation: I prefer Terraform in enterprise environments where we need reusable modules, multi-environment deployments, state management and integration with DevOps pipelines.

## Q3. What is a Terraform Provider?

Answer:

A provider is a plugin that allows Terraform to communicate with an external platform or API.

For Azure, we commonly use the AzureRM provider.

```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
```

How does it work internally?

1. Terraform reads provider configuration.
2. Terraform loads the AzureRM provider plugin.
3. Provider authenticates with Azure.
4. Terraform sends resource configuration to the provider.
5. Provider calls Azure Resource Manager APIs.
6. Azure creates or updates the resources.
7. Provider returns resource attributes.
8. Terraform updates the state file.

Important: Terraform Core handles dependency graph and execution. AzureRM provider implements resource-specific logic and Azure API interactions.

## Q4. Explain Terraform workflow.

Answer:

Terraform follows this workflow:

Write – main.tf, variables.tf

terraform init

Download providers and initialize backend

terraform validate

Validate configuration syntax and structure

terraform plan

Preview infrastructure changes

terraform apply

Execute approved infrastructure changes

Azure Infrastructure + Terraform State

## Q5. What is Terraform State File?

Answer:

Terraform state is a JSON file that maintains the mapping between Terraform configuration and real infrastructure resources.

Default file: `terraform.tfstate`

It stores:

- Resource IDs.
- Resource attributes.
- Dependency information.
- Provider-related metadata.
- Terraform-managed resource mapping.

Example:

```
{
  "resources": [
    {
      "type": "azurerm_resource_group",
      "name": "rg",
      "instances": []
    }
  ]
}
```

Why is state important?

Terraform uses state to understand which resources it manages and what changes are required during the next plan.

## Q6. What is Remote Backend in Terraform?

Answer:

A remote backend stores Terraform state outside the local machine, usually in a shared and controlled storage system.

In Azure, we use Azure Blob Storage.

```
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateprod"
    container_name       = "tfstate"
    key                  = "prod.tfstate"
  }
}
```

Benefits:

- Centralized state.
- Team collaboration.
- Blob lease-based state locking.
- State versioning and recovery options.
- Controlled access using Azure RBAC.

## Q7. What is State Locking?

Answer:

State locking prevents multiple Terraform operations from modifying the same state simultaneously.

For example:

- Engineer A executes Terraform Apply.
- Engineer B tries to execute Terraform Apply on the same state.
- Terraform detects the existing lock.
- Engineer B's operation is blocked until the lock is released.

Azure Blob backend uses Azure Blob leases for state locking.

## Q8. What is the difference between `count` and `for_each`?

Answer:

`count` creates multiple instances using numeric indexes.

```
resource "azurerm_resource_group" "rg" {
  count    = 3
  name     = "rg-${count.index}"
  location = "Central India"
}
```

`for_each` creates resources using unique keys.

```
variable "rgs" {
  default = {
    dev  = "Central India"
    prod = "East US"
  }
}

resource "azurerm_resource_group" "rg" {
  for_each = var.rgs

  name     = "rg-${each.key}"
  location = each.value
}
```

| count                                        | for_each                 |
| -------------------------------------------- | ------------------------ |
| Uses index                                   | Uses key                 |
| List-based                                   | Map or set-based         |
| Index shifting can affect resource addresses | Stable keys              |
| Best for identical instances                 | Best for named resources |

My preference: For enterprise infrastructure, I generally prefer `for_each` because resource identity remains meaningful and more stable.

## Q9. What are Terraform Modules?

Answer:

Modules are reusable collections of Terraform configuration files.

Example structure:

```
terraform-project/
│
├── main.tf
├── variables.tf
├── outputs.tf
│
└── modules/
    ├── resource-group/
    ├── networking/
    ├── storage/
    ├── keyvault/
    └── aks/
```

Calling a module:

```
module "network" {
  source              = "./modules/network"
  vnet_name           = "vnet-prod"
  resource_group_name = "rg-prod"
  location            = "Central India"
}
```

Benefits: Reusability, standardization, reduced duplication and easier enterprise governance.

## Q10. Explain `depends_on`.

Answer:

`depends_on` defines an explicit dependency between Terraform resources.

```
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}
```

There is an important distinction:

- Implicit dependency: Terraform understands dependency from resource references.
- Explicit dependency: We define it manually using `depends_on`.

Use explicit dependencies only when Terraform cannot infer the actual dependency from references.

# Section 2: Terraform Advanced Concepts

## Q11. What is the difference between Variable, Local and Output?

Answer:

| Variable                | Local                    | Output                |
| ----------------------- | ------------------------ | --------------------- |
| Takes input             | Stores calculated values | Exposes results       |
| Defined in variables.tf | Defined in locals block  | Defined in outputs.tf |
| Reusable input          | Internal calculation     | Module/CLI output     |

Example:

```
variable "location" {
  default = "Central India"
}

locals {
  environment = "prod"
  rg_name     = "rg-${local.environment}"
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
```

## Q12. What is Terraform Lifecycle?

Answer:

Lifecycle meta-arguments control how Terraform creates, updates and deletes resources.

Important lifecycle rules:

- `create_before_destroy`
- `prevent_destroy`
- `ignore_changes`
- `replace_triggered_by`

Example:

```
resource "azurerm_storage_account" "sa" {
  name                     = "stprodexample123"
  resource_group_name      = "rg-prod"
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    prevent_destroy = true
  }
}
```

This prevents accidental deletion through Terraform.

## Q13. What is Terraform Data Source?

Answer:

A data source reads information about an existing resource without managing its lifecycle.

Example:

```
data "azurerm_resource_group" "existing" {
  name = "rg-existing"
}

output "rg_location" {
  value = data.azurerm_resource_group.existing.location
}
```

Use cases:

- Read existing VNets.
- Fetch existing Resource Groups.
- Read Key Vault information.
- Reference existing subscriptions and networking.

## Q14. What is Terraform Import?

Answer:

Terraform import brings an existing infrastructure resource under Terraform management.

Suppose a Resource Group already exists in Azure Portal.

```
terraform import \
  azurerm_resource_group.rg \
  /subscriptions/SUB-ID/resourceGroups/rg-prod
```

Important: Import associates the existing object with a Terraform resource address in state. You must also write matching Terraform configuration and verify it with `terraform plan`.

Modern alternative:

```
import {
  to = azurerm_resource_group.rg
  id = "/subscriptions/SUB-ID/resourceGroups/rg-prod"
}
```

## Q15. What is Terraform Drift?

Answer:

Drift happens when someone manually modifies infrastructure outside Terraform.

Example:

- Terraform creates a VM with 4 CPUs.
- Someone manually changes the VM size from Azure Portal.
- Terraform configuration still specifies the original size.
- Terraform detects the difference during planning.

We can investigate using:

```
terraform plan -refresh-only
```

Then decide whether to:

1. Revert the manual change.
2. Update Terraform configuration to match the desired change.
3. Apply the approved reconciliation.

## Q16. What happens if Terraform State File is deleted?

Answer:

If the state file is deleted, Terraform loses its record of managed infrastructure.

The actual Azure resources generally continue running, but Terraform may propose creating duplicate resources.

Recovery approach:

1. Check Azure Blob versioning.
2. Recover the previous state version if available.
3. Check backups.
4. Validate state consistency.
5. If recovery is impossible, import existing resources.
6. Run Terraform Plan and verify all changes.

Production recommendation: Enable state versioning, restricted access and backup/restore procedures.

## Q17. What is the difference between `terraform state rm` and `terraform destroy`?

Answer:

`terraform state rm` removes the resource mapping from Terraform state but does not delete the actual Azure resource.

```
terraform state rm azurerm_resource_group.rg
```

`terraform destroy` destroys infrastructure managed by the selected configuration and state.

```
terraform destroy
```

Interview tip: Never use `state rm` as a replacement for resource deletion.

## Q18. How do you rename a Terraform resource without destroying it?

Answer:

We can use a `moved` block.

Old configuration:

```
resource "azurerm_resource_group" "old" {
  name     = "rg-prod"
  location = "Central India"
}
```

New configuration:

```
resource "azurerm_resource_group" "new" {
  name     = "rg-prod"
  location = "Central India"
}

moved {
  from = azurerm_resource_group.old
  to   = azurerm_resource_group.new
}
```

Terraform understands that the resource address has changed, not necessarily the actual infrastructure.

## Q19. What are Terraform Workspaces?

Answer:

Workspaces allow multiple state instances for the same Terraform configuration.

```
terraform workspace new dev
terraform workspace new prod

terraform workspace list
terraform workspace select prod
```

Each workspace has a separate state.

However, for large enterprise production environments, I prefer separate root configurations, backend keys and deployment pipelines where isolation and independent access controls are required.

## Q20. What is the difference between `terraform plan` and `terraform plan -out`?

Answer:

`terraform plan` displays a proposed infrastructure change.

```
terraform plan
```

`terraform plan -out=tfplan` saves the execution plan.

```
terraform plan -out=tfplan
terraform apply tfplan
```

This is useful in CI/CD because the reviewed plan can be passed to a later approval and apply stage.

Protect saved plan files because they can contain sensitive information.

# Section 3: Azure Services with Terraform

## Q21. How do you create a Resource Group?

Answer:

```
resource "azurerm_resource_group" "rg" {
  name     = "rg-production"
  location = "Central India"

  tags = {
    Environment = "Production"
    Owner       = "DevOps"
  }
}
```

Terraform calls Azure Resource Manager APIs through AzureRM provider to create the Resource Group.

## Q22. How do you create VNet with multiple subnets?

Answer:

```
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-prod"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnets" {
  for_each = {
    web = "10.0.1.0/24"
    app = "10.0.2.0/24"
    db  = "10.0.3.0/24"
  }

  name                 = "subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]
}
```

This creates three subnets dynamically.

## Q23. How do you deploy multiple Storage Accounts?

Answer:

```
variable "storage_accounts" {
  default = {
    dev  = "stdevexample123"
    prod = "stprodexample123"
  }
}

resource "azurerm_storage_account" "sa" {
  for_each = var.storage_accounts

  name                     = each.value
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

Important: Storage Account names must be globally unique and meet Azure naming requirements.

## Q24. How do you create NSG and associate it with a subnet?

Answer:

We create an NSG, define inbound/outbound rules and associate it with the subnet.

```
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-web"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  subnet_id                 = azurerm_subnet.subnets["web"].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
```

## Q25. How do you create Azure Key Vault?

Answer:

```
resource "azurerm_key_vault" "kv" {
  name                = "kv-prod-example123"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  enable_rbac_authorization = true

  soft_delete_retention_days = 90
  purge_protection_enabled   = true
}
```

For production, configure:

- Azure RBAC.
- Private Endpoint.
- Private DNS.
- Firewall/network restrictions.
- Managed Identity.
- Appropriate secret access permissions.

## Q26. How do you assign RBAC roles using Terraform?

Answer:

```
resource "azurerm_role_assignment" "reader" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = var.user_object_id
}
```

This assigns Reader permission to the specified principal at Resource Group scope.

Other common roles:

- Contributor
- Owner
- Reader
- Network Contributor
- Key Vault Secrets User

Follow least-privilege access.

## Q27. How do you create Private Endpoint?

Answer:

A Private Endpoint connects to an Azure service using a private IP from your VNet.

Example for Storage Account:

```
resource "azurerm_private_endpoint" "pe" {
  name                = "pe-storage"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnets["app"].id

  private_service_connection {
    name                           = "storage-connection"
    private_connection_resource_id = azurerm_storage_account.sa["prod"].id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}
```

In production, also configure Private DNS Zone and VNet DNS integration.

## Q28. How do you deploy AKS using Terraform?

Answer:

We use the `azurerm_kubernetes_cluster` resource.

```
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aksprod"

  default_node_pool {
    name       = "system"
    node_count = 2
    vm_size    = "Standard_D4s_v5"
  }

  identity {
    type = "SystemAssigned"
  }
}
```

Production AKS should additionally consider:

- Private cluster.
- Network architecture.
- Separate system and user node pools.
- Managed Identity.
- Azure RBAC.
- Azure Monitor.
- Autoscaling.
- Secrets integration.

## Q29. How do you configure Managed Identity?

Answer:

Managed Identity allows Azure resources to authenticate to other Azure services without storing passwords or client secrets.

Two types:

1. System-assigned Managed Identity.
2. User-assigned Managed Identity.

Example:

```
resource "azurerm_user_assigned_identity" "identity" {
  name                = "id-app-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
```

We can assign this identity permissions on Key Vault, Storage Account or other supported Azure resources.

## Q30. How do you create Azure Monitor and Log Analytics?

Answer:

We use Terraform resources:

- `azurerm_log_analytics_workspace`
- `azurerm_monitor_diagnostic_setting`
- `azurerm_monitor_action_group`
- `azurerm_monitor_metric_alert`

Example:

```
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
```

This workspace can collect logs and metrics from supported Azure services.

# Section 4: Azure DevOps + Terraform CI/CD

## Q31. Explain Terraform CI/CD Pipeline in Azure DevOps.

Answer:

I implement Terraform CI/CD using multiple stages.

[Hello World CI/CD Pipeline for Infrastructure As Code in Azure DevOps | by Syed Saad Ahmed | Medium](https://images.openai.com/static-rsc-4/F6mbPeGxmNflF5NUzj0z2h3jB6FQx7vvlm00WSN7knvcs3ICsS3-6VkLDt7MpFsfIh5vpgRHd0jeArC1_lUQWADMTpOuUj6kxAkbGrjHJBf56taGTrNRXysSo_8QqP8d7aVSRu9FeNTR0MUQKaoFKNkpwIgqD87Dw6VBvhVJKHQ?purpose=inline)

[thesaadahmed.medium.com](https://thesaadahmed.medium.com/a-basic-ci-cd-pipeline-for-infrastructure-as-a-code-in-azure-devops-84393a57137c?utm_source=chatgpt.com)

Pipeline flow:

1. Developer pushes Terraform code to Azure Repos.
2. Pipeline triggers through CI.
3. Install Terraform.
4. Run `terraform fmt`.
5. Run `terraform init`.
6. Run `terraform validate`.
7. Execute security scanning using Checkov.
8. Generate Terraform Plan.
9. Publish plan as pipeline artifact.
10. Obtain production approval.
11. Execute Terraform Apply.
12. Validate deployed resources.

Example YAML:

```
trigger:
  branches:
    include:
      - main

pool:
  vmImage: ubuntu-latest

stages:
- stage: Validate
  jobs:
  - job: TerraformValidate
    steps:
    - script: |
        terraform init
        terraform fmt -check
        terraform validate
      displayName: Validate Terraform

- stage: Plan
  dependsOn: Validate
  jobs:
  - job: TerraformPlan
    steps:
    - script: terraform plan -out=tfplan

- stage: Apply
  dependsOn: Plan
  jobs:
  - deployment: TerraformApply
    environment: production
    strategy:
      runOnce:
        deploy:
          steps:
          - script: terraform apply -auto-approve tfplan
```

For production, I would additionally configure secure authentication, backend initialization, artifact publishing/downloading, approval checks, and ensure that the Apply stage uses exactly the reviewed plan.

## Q32. How do you authenticate Terraform with Azure?

Answer:

There are multiple authentication approaches:

1. Service Principal with client secret.
2. Service Principal with certificate.
3. Managed Identity.
4. Workload Identity Federation (OIDC).

Example using environment variables:

```
export ARM_CLIENT_ID="client-id"
export ARM_TENANT_ID="tenant-id"
export ARM_SUBSCRIPTION_ID="subscription-id"
export ARM_USE_OIDC=true
```

In production, I prefer OIDC federation because it avoids long-lived client secrets.

## Q33. How do you manage Terraform secrets?

Answer:

I use Azure Key Vault and secure pipeline authentication.

Approach:

1. Store secrets in Key Vault.
2. Configure pipeline identity.
3. Grant minimum required permissions.
4. Retrieve secrets during execution only when required.
5. Pass secrets through protected environment variables.
6. Never commit secrets to Git.

Important: Terraform state and plan files may contain sensitive values even when variables are marked `sensitive = true`. Protect both.

## Q34. How do you implement approval before production deployment?

Answer:

I use Azure DevOps Environments with approval checks.

Flow:

```
Developer Commit
      |
Terraform Validate
      |
Security Scan
      |
Terraform Plan
      |
Publish Plan Artifact
      |
Manual Approval
      |
Terraform Apply
      |
Production Verification
```

Only authorized approvers can approve production deployments.

## Q35. How do you implement Terraform security scanning?

Answer:

I integrate the following tools:

| Tool      | Purpose                        |
| --------- | ------------------------------ |
| Checkov   | IaC security scanning          |
| tfsec     | Terraform security checks      |
| Trivy     | Vulnerability and IaC scanning |
| TFLint    | Terraform linting              |
| Terrascan | IaC policy checks              |
| Infracost | Infrastructure cost estimation |

Example:

```
terraform fmt -check
terraform validate
tflint
checkov -d .
trivy config .
terraform plan
```

Security scanning should happen before production approval.

# Section 5: Production Troubleshooting Scenarios

## Q36. What happens if Terraform Apply fails halfway?

Answer:

Terraform may have successfully created some resources before encountering an error.

My troubleshooting approach:

1. Check the pipeline logs.
2. Identify which resource failed.
3. Check the actual Azure resource status.
4. Verify Terraform state.
5. Fix the underlying issue.
6. Execute another Terraform Plan.
7. Review and apply the remaining changes.

Terraform does not provide an automatic transactional rollback of all previously created resources.

## Q37. Two engineers execute Terraform Apply simultaneously. What happens?

Answer:

If both use the same Azure Blob backend state, blob lease-based locking protects the state from concurrent modifications.

One operation obtains the lock; the other waits or fails with a state-lock error.

My recommendation:

- Use remote backend.
- Avoid force-unlock without investigation.
- Use a centralized CI/CD deployment pipeline.
- Never allow uncontrolled production applies.

## Q38. Someone manually deletes a Resource Group from Azure Portal. How do you handle it?

Answer:

First, I check the Terraform state and Azure resource status.

Then:

```
terraform plan
```

Terraform should identify that the managed resource is missing and may propose recreation.

I check:

1. Whether the deletion was intentional.
2. Whether other dependent resources were deleted.
3. Whether the Terraform configuration is still valid.
4. Whether recreating the resource is safe.

For production, I investigate the impact before applying.

## Q39. Terraform Plan wants to replace an existing VM. What will you do?

Answer:

I investigate why Terraform wants to replace the VM.

Possible reasons:

- ForceNew attribute changed.
- Resource configuration changed.
- Immutable property modified.
- Provider behavior or API changes.
- State drift.

I execute:

```
terraform plan
terraform show tfplan
```

Then inspect the changed attributes.

If replacement is unnecessary, I correct the configuration or investigate state. I never blindly approve production replacement.

## Q40. How do you manage Dev, QA, UAT and Production environments?

Answer:

I generally use reusable Terraform modules with separate environment configurations and independent state files.

Example:

```
terraform/
│
├── modules/
│   ├── networking/
│   ├── storage/
│   └── compute/
│
├── environments/
│   ├── dev/
│   ├── qa/
│   ├── uat/
│   └── prod/
```

Each environment has:

- Separate variables.
- Separate backend state key.
- Environment-specific access permissions.
- Separate deployment approvals.
- Common reusable modules.

This gives us consistency with environment isolation.

# Section 6: Senior Azure Architect – Scenario-Based Answers

## Q41. How will you design Hub-Spoke architecture using Terraform?

Answer:

I design the architecture using a centralized Hub VNet and multiple Spoke VNets.

[GitHub - BaldbullTech/002-HubSpokeTopology: Sample code to build hub-spoke network in Azure · GitHub](https://images.openai.com/static-rsc-4/ogh4lgGYBet00O-YuOzQfeitG_zm-idgxvBf9dXvmfle495DLOQ5xi0W_KfuE6xMu5_6ELUvwuWxz3R7NzCkSw3UC8hkjVkIURE2BAOCts5EWxoF5QHiW_GjqtCSrdk_1p4ESwGWcp4z_MztbNavP83v91t6miEILAWxA58RRtU?purpose=inline)

[github.com](https://github.com/BaldbullTech/002-HubSpokeTopology?utm_source=chatgpt.com)

Hub contains:

- Azure Firewall.
- VPN Gateway or ExpressRoute Gateway.
- Bastion.
- Centralized DNS and shared networking services.

Spokes contain:

- Application workloads.
- Database services.
- AKS clusters.
- Web applications.

Implementation steps:

1. Create Hub Resource Group.
2. Create Hub VNet and subnets.
3. Deploy Azure Firewall.
4. Create Spoke VNets.
5. Configure VNet peering.
6. Configure route tables and UDRs.
7. Associate UDRs with required subnets.
8. Configure DNS resolution.
9. Apply NSG and Azure Policy.
10. Monitor traffic centrally.

Terraform modules can standardize this across subscriptions.

## Q42. How will you manage 10 Azure subscriptions using Terraform?

Answer:

I use a centralized Landing Zone approach.

1. Create Management Group hierarchy.
2. Define subscription-level governance.
3. Configure provider authentication.
4. Use provider aliases for multiple subscriptions.
5. Create shared networking and security modules.
6. Maintain separate state per subscription or deployment boundary.
7. Implement centralized CI/CD.
8. Apply Azure Policy and RBAC.

Example:

```
provider "azurerm" {
  alias           = "dev"
  subscription_id = var.dev_subscription_id
  features {}
}

provider "azurerm" {
  alias           = "prod"
  subscription_id = var.prod_subscription_id
  features {}
}

resource "azurerm_resource_group" "dev" {
  provider = azurerm.dev

  name     = "rg-dev"
  location = "Central India"
}

resource "azurerm_resource_group" "prod" {
  provider = azurerm.prod

  name     = "rg-prod"
  location = "Central India"
}
```

For enterprise use, I would separate deployment states and permissions rather than managing all subscriptions through one large state.

## Q43. How do you implement Azure Policy using Terraform?

Answer:

Azure Policy enforces organizational standards.

Examples:

- Restrict allowed regions.
- Require resource tags.
- Restrict public IP creation.
- Enforce diagnostic logging.
- Restrict allowed VM SKUs.

Terraform resources include:

```
resource "azurerm_policy_definition" "allowed_location" {
  name         = "allowed-locations"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Azure Locations"

  policy_rule = jsonencode({
    if = {
      field  = "location"
      notIn  = ["centralindia", "eastus"]
    }
    then = {
      effect = "Deny"
    }
  })
}
```

We can assign policies at Management Group, Subscription or Resource Group scope.

## Q44. How do you manage Disaster Recovery using Terraform?

Answer:

I use Terraform to provision the infrastructure required for DR.

Implementation:

1. Define primary and secondary Azure regions.
2. Provision networking in both regions.
3. Configure Azure Site Recovery where applicable.
4. Configure database replication.
5. Configure Storage redundancy.
6. Deploy application infrastructure.
7. Configure Traffic Manager or Front Door.
8. Store environment-specific configurations.
9. Conduct DR testing.
10. Validate RTO and RPO.

Important: Terraform provisions and manages infrastructure, but it does not independently guarantee application data replication or DR failover.

## Q45. How do you optimize Azure infrastructure costs using Terraform?

Answer:

I use a combination of infrastructure design, monitoring and cost analysis.

- Select appropriate VM SKUs.
- Configure autoscaling.
- Use appropriate Storage redundancy.
- Remove unused resources.
- Apply tags for cost allocation.
- Use Infracost during Terraform Plan.
- Monitor Azure Cost Management.
- Use reservations or savings plans where suitable.

Terraform defines the desired configuration; Azure Cost Management provides actual usage and cost insights.

## Q46. How do you manage Terraform modules across multiple projects?

Answer:

I maintain a centralized module repository in Azure Repos or GitHub.

Example:

```
terraform-modules/
│
├── azure-network/
├── azure-storage/
├── azure-keyvault/
├── azure-aks/
├── azure-vm/
└── azure-monitoring/
```

Consume modules using Git:

```
module "network" {
  source = "git::https://dev.azure.com/org/project/_git/terraform-modules//network?ref=v1.0.0"
}
```

I follow:

- Semantic versioning.
- Code reviews.
- Module testing.
- Documentation.
- Backward compatibility.
- Controlled releases.

## Q47. How do you handle Terraform provider version upgrades?

Answer:

I follow a controlled upgrade process.

1. Check the latest compatible provider version.
2. Update `required_providers`.
3. Run `terraform init -upgrade`.
4. Review `.terraform.lock.hcl`.
5. Run Terraform Validate.
6. Execute Terraform Plan.
7. Test in Dev.
8. Promote to Production after approval.

I never upgrade the provider directly in Production without testing compatibility.

## Q48. How do you implement Infrastructure as Code security?

Answer:

I implement security at multiple layers.

| Layer          | Implementation                    |
| -------------- | --------------------------------- |
| Source code    | Git branch protection             |
| Code quality   | TFLint                            |
| IaC security   | Checkov, Trivy                    |
| Identity       | OIDC, Managed Identity            |
| Secrets        | Azure Key Vault                   |
| Infrastructure | NSG, Private Endpoints            |
| Governance     | Azure Policy                      |
| Deployment     | Approval gates                    |
| Monitoring     | Azure Monitor, Defender for Cloud |

My goal is to implement DevSecOps from code commit to production deployment.

## Q49. What is the difference between Terraform and Ansible?

Answer:

| Terraform                        | Ansible                                                    |
| -------------------------------- | ---------------------------------------------------------- |
| Infrastructure provisioning      | Configuration management and automation                    |
| Declarative IaC                  | Primarily task-based automation                            |
| Maintains state                  | Generally agentless and does not use Terraform-style state |
| Creates Azure resources          | Configures operating systems and applications              |
| Manages infrastructure lifecycle | Automates operational tasks                                |

Real-world example:

Terraform creates:

- Azure VM.
- VNet.
- NSG.
- Load Balancer.

Ansible configures:

- Linux packages.
- Nginx.
- Application configuration.
- OS hardening.

Both tools can work together in enterprise automation.

## Q50. Explain an end-to-end Azure Terraform project that you handled.

Answer – Sample interview response:

"In my project, I worked on automating enterprise Azure infrastructure using Terraform and Azure DevOps.

We designed a modular architecture with separate Dev, UAT and Production environments.

First, we created Resource Groups, Hub-Spoke networking, NSGs, Storage Accounts, Key Vaults and Private Endpoints using reusable Terraform modules.

We configured Azure Blob Storage as the remote backend for centralized state management and state locking.

For CI/CD, we integrated Terraform with Azure DevOps pipelines.

Our pipeline performed formatting, validation, security scanning, Terraform Plan, manual approval and Terraform Apply.

For authentication, we used workload identity federation to avoid storing long-lived credentials.

We also implemented Azure Policy, RBAC, monitoring and tagging standards.

This approach helped us standardize infrastructure provisioning, improve security, reduce manual effort and maintain consistency across environments."
