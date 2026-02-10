# Variables in Terraform

### Variable Types
- What is a variable? why we need it?
  - Variable is a Place holder of value.
  - Reuse of the TF code.
  - Avoid human error (while copying we forgot to update the tag)
  - Update in one place and refelect in all the place its reffered.

#### Based on purpose
- **INPUT**
```
# Initialize the variable
variable "environment" {
  default = "dev"
  type = string
}

var.environment # to access the variable
```
- **OUTPUT**
  - Prints it on the console.
  - Use it to output the details of the created resources
```
output "vpc_id" {
  value = aws_vpc-sample.id
}

output "ec2_id" {
  value = aws_instance.example.id
}
```
- **LOCALS**
```
${} -> String concatenetion
"${var.environment}-Bucket"
locals {
  bucket_name = "bucket-name-${var.environment}"
  vpc_name = "${var.environment}-VPC"
}

local.bucket_name  # Access the value
```
#### Based on values
- Primitive
  - String
  - Number
  - BOOL
- Complex
  - List
  - Set
  - Map
  - Object
  - Tuple
- ANY


